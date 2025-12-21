import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

interface Product {
    id: number;
    name: string;
    category: string;
    description: string;
    price: number;
    imageUrl: string;
}

interface Order {
    id?: number;
    customerName: string;
    customerEmail: string;
    productNames: string[];
    totalAmount: number;
    orderDate?: string;
    status?: string;
}

interface Translation {
    [key: string]: {
        [key: string]: string;
    };
}

@Component({
    selector: 'app-root',
    standalone: true,
    imports: [CommonModule, FormsModule],
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
    products: Product[] = [];
    orders: Order[] = [];
    cart: Product[] = [];

    // UI State
    isCartOpen = false;
    orderPlaced = false;
    currentView: 'shop' | 'admin' | 'contact' = 'shop';
    currentCategory = 'All';
    searchQuery = '';
    lastOrderTotal = 0;
    isDarkMode = true;
    currentLang: 'fr' | 'en' | 'ar' = 'fr';
    isMobileMenuOpen = false;

    // Contact Form
    contactForm = {
        name: '',
        email: '',
        subject: '',
        message: ''
    };
    contactMsgSent = false;

    customer = {
        name: '',
        email: ''
    };

    categories = ['All', 'Laptops', 'Monitors', 'Audio', 'Gadgets', 'Accessories', 'Office'];

    translations: Translation = {
        fr: {
            store: 'Boutique',
            admin: 'Administration',
            contact: 'Contact',
            cart: 'Panier',
            search: 'Rechercher un produit...',
            welcome: 'Améliorez votre espace de travail',
            hero_p: 'Collection premium de matériel haute performance pour les développeurs et créatifs.',
            available: 'En stock',
            add_to_cart: 'Ajouter au panier',
            total: 'Total',
            checkout: 'Vérifier et commander',
            order_success: 'Commande réussie !',
            revenue: 'Chiffre d\'affaires',
            orders_title: 'Gestion des Commandes',
            contact_title: 'Contactez-nous',
            send: 'Envoyer le message',
            lang: 'Langue',
            theme: 'Thème',
            filter: 'Tous les produits',
            no_orders: 'Aucune commande détectée.'
        },
        en: {
            store: 'Store',
            admin: 'Admin',
            contact: 'Contact',
            cart: 'Cart',
            search: 'Search products...',
            welcome: 'Upgrade Your Workspace',
            hero_p: 'Premium curated collection of High-Performance hardware for Developers.',
            available: 'In Stock',
            add_to_cart: 'Add to Cart',
            total: 'Total',
            checkout: 'Place Order',
            order_success: 'Order Successful!',
            revenue: 'Gross Revenue',
            orders_title: 'Order Management',
            contact_title: 'Contact Us',
            send: 'Send Message',
            lang: 'Language',
            theme: 'Theme',
            filter: 'All products',
            no_orders: 'No orders found.'
        },
        ar: {
            store: 'المتجر',
            admin: 'الإدارة',
            contact: 'اتصل بنا',
            cart: 'السلة',
            search: 'البحث عن المنتجات...',
            welcome: 'قم بترقية مساحة عملك',
            hero_p: 'مجموعة متميزة من الأجهزة عالية الأداء للمبرمجين والمبدعين.',
            available: 'في المخزن',
            add_to_cart: 'أضف إلى السلة',
            total: 'المجموع',
            checkout: 'إتمام الطلب',
            order_success: 'تم الطلب بنجاح!',
            revenue: 'إجمالي الإيرادات',
            orders_title: 'إدارة الطلبات',
            contact_title: 'اتصل بنا',
            send: 'إرسال الرسالة',
            lang: 'اللغة',
            theme: 'الوضع',
            filter: 'جميع المنتجات',
            no_orders: 'لم يتم العثور على طلبات.'
        }
    };

    constructor(private http: HttpClient) { }

    ngOnInit() {
        this.loadProducts();
        // Initial language set to French
    }

    t(key: string): string {
        return this.translations[this.currentLang][key] || key;
    }

    loadProducts() {
        this.http.get<Product[]>('/api/products').subscribe({
            next: (data: Product[]) => this.products = data,
            error: (err: any) => console.error('Error loading products', err)
        });
    }

    loadOrders() {
        this.http.get<Order[]>('/api/orders').subscribe({
            next: (data: Order[]) => this.orders = data,
            error: (err: any) => console.error('Error loading orders', err)
        });
    }

    get filteredProducts() {
        return this.products.filter(p => {
            const matchesCategory = this.currentCategory === 'All' || p.category === this.currentCategory;
            const matchesSearch = p.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                p.description.toLowerCase().includes(this.searchQuery.toLowerCase());
            return matchesCategory && matchesSearch;
        });
    }

    get totalRevenue() {
        return this.orders.reduce((acc, o) => acc + o.totalAmount, 0);
    }

    addToCart(product: Product) {
        this.cart.push(product);
    }

    removeFromCart(index: number) {
        this.cart.splice(index, 1);
    }

    get total() {
        return this.cart.reduce((sum, p) => sum + p.price, 0);
    }

    checkout() {
        if (!this.customer.name || !this.customer.email || this.cart.length === 0) return;

        this.lastOrderTotal = this.total;
        const order: Order = {
            customerName: this.customer.name,
            customerEmail: this.customer.email,
            productNames: this.cart.map(p => p.name),
            totalAmount: this.lastOrderTotal
        };

        this.http.post<Order>('/api/orders', order).subscribe({
            next: () => {
                this.orderPlaced = true;
                this.cart = [];
                this.isCartOpen = false;
                this.loadOrders();
                setTimeout(() => this.orderPlaced = false, 5000);
            }
        });
    }

    sendContact() {
        this.http.post('/api/contact', this.contactForm).subscribe({
            next: () => {
                this.contactMsgSent = true;
                this.contactForm = { name: '', email: '', subject: '', message: '' };
                setTimeout(() => this.contactMsgSent = false, 5000);
            }
        });
    }

    updateOrderStatus(orderId: number, status: string) {
        this.http.put(`/api/orders/${orderId}/status`, { status }).subscribe({
            next: () => this.loadOrders()
        });
    }

    switchView(view: 'shop' | 'admin' | 'contact') {
        this.currentView = view;
        this.isMobileMenuOpen = false;
        if (view === 'admin') {
            this.loadOrders();
        }
    }

    toggleTheme() {
        this.isDarkMode = !this.isDarkMode;
    }

    setLanguage(lang: 'fr' | 'en' | 'ar') {
        this.currentLang = lang;
        document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
    }

    toggleCart() {
        this.isCartOpen = !this.isCartOpen;
    }

    toggleMobileMenu() {
        this.isMobileMenuOpen = !this.isMobileMenuOpen;
    }
}
