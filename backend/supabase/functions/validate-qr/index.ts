import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
    try {
        const { token } = await req.json();

        // Initialize Supabase Client (Service Role for admin access)
        const supabase = createClient(
            Deno.env.get("SUPABASE_URL") ?? "",
            Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
        );

        // 1. Fetch Token Data
        const { data: qrData, error: qrError } = await supabase
            .from("qr_tokens")
            .select("*, orders(*, products(*))")
            .eq("token_hash", token)
            .single();

        if (qrError || !qrData) {
            return new Response(JSON.stringify({ error: "Invalid QR Code" }), { status: 400 });
        }

        // 2. Security Checks
        if (qrData.is_used) {
            return new Response(JSON.stringify({ error: "QR Code Already Used" }), { status: 400 });
        }

        if (new Date() > new Date(qrData.expires_at)) {
            return new Response(JSON.stringify({ error: "QR Code Expired" }), { status: 400 });
        }

        if (qrData.orders.order_status !== "paid" && qrData.orders.order_status !== "PAID") {
            return new Response(JSON.stringify({ error: "Payment not verified" }), { status: 400 });
        }

        // 3. Mark as Used (Atomic Transaction)
        const { error: updateError } = await supabase.rpc("mark_qr_used", {
            qr_id: qrData.id,
            order_id: qrData.orders.id
        });

        if (updateError) {
            // Fallback if RPC not defined
            await supabase.from("qr_tokens").update({ is_used: true }).eq("id", qrData.id);
            await supabase.from("orders").update({ order_status: "completed" }).eq("id", qrData.orders.id);
        }

        // 4. Return Success to IoT Device
        return new Response(
            JSON.stringify({
                action: "DISPENSE",
                slot: qrData.orders.products.motor_slot_id,
                product_name: qrData.orders.products.name,
            }),
            { headers: { "Content-Type": "application/json" } }
        );

    } catch (error) {
        return new Response(JSON.stringify({ error: error.message }), { status: 500 });
    }
});
