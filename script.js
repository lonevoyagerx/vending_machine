/* ================================================================
   SmartVend – FULL WORKING VERSION
   ================================================================ */

console.log("🔥 JS LOADED");

// ── Products ───────────────────────────────────────────────────
let PRODUCTS = [];

// ── Cart ───────────────────────────────────────────────────────
let CART = [];

// ── Supabase Config ───────────────────────────────────────────
const SUPABASE_URL = 'https://ihnvropaqzmjxikxgggd.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlobnZyb3BhcXptanhpa3hnZ2dkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzMTIxMjIsImV4cCI6MjA4NTg4ODEyMn0.YQAo2wx4SnBqFQuvgB5xzOf7ycYaiZxtvxaWUdj09IE';
// ── FETCH PRODUCTS ─────────────────────────────────────────────
async function fetchProductsFromSupabase() {
    console.log("🚀 Fetching products...");

    try {
        const res = await fetch(`${SUPABASE_URL}/rest/v1/products?select=*`, {
            headers: {
                apikey: SUPABASE_ANON_KEY,
                Authorization: `Bearer ${SUPABASE_ANON_KEY}`
            }
        });

        const data = await res.json();
        console.log("🔥 DATA:", data);

        // ✅ IMPORTANT FIX (map whichever columns your DB uses)
        PRODUCTS = data.map(p => {
            const name = p.product_name || p.name || 'Unknown';
            const stock = p.stoc ?? p.stock_quantity ?? 0;

            return {
                id: p.id,
                name,
                price: p.price,
                available: stock > 0
            };
        });

        renderProducts();

    } catch (err) {
        console.error("❌ ERROR:", err);
    }
}

// ── HELPERS ───────────────────────────────────────────────────
function formatCurrency(value) {
    return `₹${Number(value).toFixed(2)}`;
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString(undefined, {
        year: 'numeric',
        month: 'short',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// ── ORDERS ───────────────────────────────────────────────────
async function fetchOrdersFromSupabase() {
    const container = document.getElementById('orders-list');
    if (!container) return;

    container.innerHTML = `<div class="loading">Loading orders…</div>`;

    try {
        const res = await fetch(`${SUPABASE_URL}/rest/v1/orders?select=*&order=created_at.desc`, {
            headers: {
                apikey: SUPABASE_ANON_KEY,
                Authorization: `Bearer ${SUPABASE_ANON_KEY}`
            }
        });

        if (!res.ok) throw new Error(`HTTP ${res.status}`);

        const data = await res.json();
        console.log("🔥 ORDERS:", data);
        renderOrders(data);

    } catch (err) {
        console.error("❌ Orders fetch error:", err);
        container.innerHTML = `<div class="no-results">Unable to load orders. Check console for details.</div>`;
    }
}

function renderOrders(orders) {
    const container = document.getElementById('orders-list');
    if (!container) return;

    if (!Array.isArray(orders) || orders.length === 0) {
        container.innerHTML = `<div class="no-results">No orders yet.</div>`;
        return;
    }

    container.innerHTML = orders.map(order => {
        const status = (order.status || order.order_status || '').toLowerCase();
        const statusClass = status === 'paid' ? 'status-paid' : status === 'dispensed' ? 'status-dispensed' : 'status-pending';
        const product = PRODUCTS.find(p => `${p.id}` === `${order.product_id}`);
        const productName = product?.name || order.product_name || order.product_id || 'Unknown product';

        return `
            <div class="order-card">
                <div class="order-header">
                    <div class="order-id">${order.id}</div>
                    <div class="order-status ${statusClass}">${(status || 'pending').toUpperCase()}</div>
                </div>
                <div class="order-body">
                    <div class="order-item">
                        <div class="item-name">${productName}</div>
                        <div class="item-price">${formatCurrency(order.amount || order.price || 0)}</div>
                    </div>
                    <div class="order-date">${formatDate(order.created_at || order.createdAt || Date.now())}</div>
                </div>
            </div>
        `;
    }).join('');
}

// ── RENDER PRODUCTS ───────────────────────────────────────────
function renderProducts() {
    const grid = document.getElementById('products-grid');

    if (!grid) {
        console.error("❌ products-grid not found");
        return;
    }

    grid.innerHTML = PRODUCTS.map(p => `
        <div class="product-card">
            <h3>${p.name}</h3>
            <p>₹${p.price}</p>
            <button onclick="addToCart('${p.id}')" ${!p.available ? 'disabled' : ''}>
                ${p.available ? 'Add to Cart' : 'Out of Stock'}
            </button>
        </div>
    `).join('');
}

// ── ADD TO CART ───────────────────────────────────────────────
function addToCart(id) {
    const product = PRODUCTS.find(p => p.id === id);

    if (!product || !product.available) {
        alert("Out of stock!");
        return;
    }

    CART.push(product);
    alert("✅ Added to cart");
}

// ── SEND ORDER ────────────────────────────────────────────────
async function payNow() {
    if (CART.length === 0) {
        alert("Cart is empty!");
        return;
    }

    // NOTE: Supabase RLS may require an authenticated user. If you're seeing empty results
    // or failures, ensure you are signed in or disable RLS for the `orders` table for testing.
    const rows = CART.map(item => ({
        product_id: item.id,
        amount: item.price,
        status: 'PAID'
    }));

    try {
        const res = await fetch(`${SUPABASE_URL}/rest/v1/orders`, {
            method: 'POST',
            headers: {
                apikey: SUPABASE_ANON_KEY,
                Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(rows)
        });

        if (!res.ok) {
            const body = await res.text();
            throw new Error(`Order failed (${res.status}): ${body}`);
        }

        alert("💰 Payment successful!");
        CART = [];

    } catch (err) {
        console.error(err);
        alert("❌ Payment failed");
    }
}

// ── INIT ─────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
    console.log("🔥 DOM READY");
    fetchProductsFromSupabase();

    // Load orders when on the orders page
    if (document.body.dataset.page === 'orders') {
        fetchOrdersFromSupabase();
    }
});