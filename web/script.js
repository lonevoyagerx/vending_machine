/* ================================================================
   SmartVend – FINAL FIXED CODE
   ================================================================ */

// ── CONFIG ───────────────────────────────────────────────
const SUPABASE_URL = 'https://ihnvropaqzmjxikxgggd.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlobnZyb3BhcXptanhpa3hnZ2dkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzMTIxMjIsImV4cCI6MjA4NTg4ODEyMn0.YQAo2wx4SnBqFQuvgB5xzOf7ycYaiZxtvxaWUdj09IE';

let PRODUCTS = [];
const CART_KEY = 'sv_cart';

// ── FETCH PRODUCTS ───────────────────────────────────────
async function fetchProducts() {
    try {
        const res = await fetch(`${SUPABASE_URL}/rest/v1/products?select=*`, {
            headers: {
                apikey: SUPABASE_KEY,
                Authorization: `Bearer ${SUPABASE_KEY}`
            }
        });

        const data = await res.json();
        console.log("Products:", data);

        PRODUCTS = data.map(p => ({
            id: p.id,
            name: p.product_name || "No Name",
            price: p.price || 0,
            category: p.category || "general",
            emoji: p.emoji || "🛒",
            available: p.available !== false
        }));

    } catch (err) {
        console.error("Fetch Error:", err);
    }
}

// ── PRODUCTS UI ─────────────────────────────────────────
async function initProducts() {
    await fetchProducts();
    renderProducts();
}

function renderProducts() {
    const grid = document.getElementById('products-grid');
    if (!grid) return;

    grid.innerHTML = PRODUCTS.map(p => `
        <div class="product-card">
            <div style="font-size:40px">${p.emoji}</div>
            <h3>${p.name}</h3>
            <strong>₹${p.price}</strong>
            <button class="add-btn" data-id="${p.id}">
                Add
            </button>
        </div>
    `).join('');

    // 🔥 FIXED CLICK HANDLER
    document.querySelectorAll('.add-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const id = btn.dataset.id;
            addToCart(id);

            btn.innerText = "Added ✅";
            setTimeout(() => btn.innerText = "Add", 1000);
        });
    });
}

// ── CART ────────────────────────────────────────────────
function getCart() {
    return JSON.parse(localStorage.getItem(CART_KEY)) || [];
}

function saveCart(cart) {
    localStorage.setItem(CART_KEY, JSON.stringify(cart));
    updateCartBadge();
}

function addToCart(id) {
    const cart = getCart();
    const product = PRODUCTS.find(p => String(p.id) === String(id));

    if (!product) return;

    const item = cart.find(i => String(i.id) === String(id));

    if (item) item.qty++;
    else cart.push({ ...product, qty: 1 });

    saveCart(cart);
}

function updateCartBadge() {
    const count = getCart().reduce((sum, item) => sum + item.qty, 0);
    const badge = document.getElementById('cart-count');

    if (badge) badge.innerText = count;
}

// ── CART PAGE ───────────────────────────────────────────
function renderCart() {
    const cart = getCart();
    const container = document.getElementById('cart-items');

    if (!container) return;

    if (cart.length === 0) {
        container.innerHTML = "<p>Cart is empty</p>";
        return;
    }

    container.innerHTML = cart.map(item => `
        <div class="cart-item">
            <div>
                <strong>${item.name}</strong>
                <div>₹${item.price} × ${item.qty}</div>
            </div>
            <div>
                <button onclick="updateQty('${item.id}', -1)">−</button>
                <button onclick="updateQty('${item.id}', 1)">+</button>
            </div>
        </div>
    `).join('');
}

function updateQty(id, delta) {
    let cart = getCart();
    const item = cart.find(i => String(i.id) === String(id));

    if (!item) return;

    item.qty += delta;

    if (item.qty <= 0) {
        cart = cart.filter(i => String(i.id) !== String(id));
    }

    saveCart(cart);
    renderCart();
}

// ── ORDER ───────────────────────────────────────────────
async function placeOrder() {
    const cart = getCart();

    if (cart.length === 0) {
        alert("Cart empty!");
        return;
    }

    const total = cart.reduce((sum, i) => sum + i.price * i.qty, 0);

    try {
        await fetch(`${SUPABASE_URL}/rest/v1/orders`, {
            method: "POST",
            headers: {
                apikey: SUPABASE_KEY,
                Authorization: `Bearer ${SUPABASE_KEY}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                items: cart,
                amount: total,
                status: "PAID"
            })
        });

        alert("✅ Order placed!");
        localStorage.removeItem(CART_KEY);
        updateCartBadge();

    } catch (err) {
        console.error("Order Error:", err);
    }
}

// ── ORDERS PAGE ─────────────────────────────────────────
async function loadOrders() {
    const container = document.getElementById('orders-list');
    if (!container) return;

    try {
        const res = await fetch(`${SUPABASE_URL}/rest/v1/orders?select=*`, {
            headers: {
                apikey: SUPABASE_KEY,
                Authorization: `Bearer ${SUPABASE_KEY}`
            }
        });

        const orders = await res.json();

        container.innerHTML = orders.map(o => `
            <div class="order-card">
                <div><strong>ID:</strong> ${o.id}</div>
                <div><strong>Amount:</strong> ₹${o.amount}</div>
                <div><strong>Status:</strong> ${o.status}</div>
            </div>
        `).join('');

    } catch (err) {
        console.error(err);
    }
}

// ── INIT ────────────────────────────────────────────────
document.addEventListener("DOMContentLoaded", () => {
    updateCartBadge();

    if (document.body.dataset.page === "products") initProducts();
    if (document.body.dataset.page === "cart") renderCart();
    if (document.body.dataset.page === "orders") loadOrders();
});