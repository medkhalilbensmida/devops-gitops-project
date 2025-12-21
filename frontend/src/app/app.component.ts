import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

interface Product {
    id: number;
    nameKey: string;
    categoryKey: string;
    descKey: string;
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
    status: string;
}

interface TranslationMap {
    [key: string]: { [key: string]: string };
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
    currentCategory = 'cat_all';
    searchQuery = '';
    lastOrderTotal = 0;
    isDarkMode = true;
    currentLang: 'fr' | 'en' | 'ar' = 'fr';
    isMobileMenuOpen = false;

    // Contact Form
    contactForm = { name: '', email: '', subject: '', message: '' };
    contactMsgSent = false;

    customer = { name: '', email: '' };

    categories = ['cat_all', 'cat_laptops', 'cat_monitors', 'cat_audio', 'cat_gadgets', 'cat_accessories', 'cat_office'];

    translations: TranslationMap = {
        fr: {
            store: 'Boutique',
            admin: 'Dashboard Admin',
            contact: 'Contactez-nous',
            cart: 'Mon Panier',
            search_placeholder: 'Rechercher un produit d\'exception...',
            hero_title: 'L\'Excellence Technologique',
            hero_subtitle: 'Découvrez notre collection premium de matériel haute performance conçue pour les visionnaires.',
            cat_all: 'Tous les Produits',
            cat_laptops: 'Ordinateurs',
            cat_monitors: 'Moniteurs',
            cat_audio: 'Audio & Son',
            cat_gadgets: 'Gadgets IA',
            cat_accessories: 'Accessoires',
            cat_office: 'Bureau Pro',
            available: 'Disponible immédiatement',
            add_to_cart: 'Ajouter au Panier',
            total_label: 'Sous-total',
            checkout_btn: 'Confirmer la Commande',
            order_success_title: 'Commande Confirmée',
            order_success_msg: 'Votre transaction a été traitée avec succès.',
            revenue_label: 'Chiffre d\'Affaires Global',
            total_orders: 'Commandes Totales',
            platform_status: 'État du Système',
            operational: 'Opérationnel',
            recent_orders: 'Transactions Récentes',
            cust_details: 'Détails Client',
            purchased_items: 'Articles Achetés',
            order_date: 'Date d\'Achat',
            actions: 'Actions',
            status_pending: 'En Attente',
            status_shipped: 'Expédié',
            status_delivered: 'Livré',
            ship_btn: 'Expédier',
            deliver_btn: 'Livrer',
            empty_orders: 'Aucune commande enregistrée à ce jour.',
            contact_name: 'Votre Nom complet',
            contact_email: 'Adresse Email',
            contact_subject: 'Sujet du message',
            contact_msg: 'Comment pouvons-nous vous aider ?',
            send_msg: 'Envoyer le Message',
            contact_success: 'Votre message a été envoyé à nos équipes.',
            footer_text: 'Plateforme E-commerce de Luxe propulsée par Kubernetes et GitOps.',
            close: 'Fermer',
            items_count: 'articles',
            lang_label: 'Langue',
            theme_label: 'Thème',
            // Product Translations
            prod_laptop_hp: 'EliteBook Pro X1',
            desc_laptop_hp: 'Le summum de la productivité mobile pour développeurs exigeants.',
            prod_laptop_mbp: 'MacBook Pro M3 Max',
            desc_laptop_mbp: 'La puissance brute rencontrant l\'élégance absolue d\'Apple.',
            prod_laptop_razer: 'Razer Blade Stealth 16',
            desc_laptop_razer: 'Quand la finesse rencontre le gaming de haut vol.',
            prod_mon_5k: 'Écran UltraWide 5K Pro',
            desc_mon_5k: 'Une immersion totale avec une précision colorimétrique studio.',
            prod_mon_g9: 'Samsung Odyssey Neo G9',
            desc_mon_g9: 'Le futur du display : Courbure 1000R et Mini-LED.',
            prod_kb_mx: 'Clavier Mécanique MX Pro',
            desc_kb_mx: 'Ressenti tactile inégalé pour une frappe rapide et précise.',
            prod_mouse_mx: 'Souris Logitech MX Master 3S',
            desc_mouse_mx: 'Précision chirurgicale et ergonomie avancée pour pro.',
            prod_audio_studio: 'Casque Studio HD-800',
            desc_audio_studio: 'Réduction de bruit adaptative pour une concentration totale.',
            prod_audio_pods: 'AirPods Max Graphite',
            desc_audio_pods: 'Le son haute fidélité redéfini par une ingénierie de pointe.',
            prod_gadget_drone: 'Drone DJI Mavic 3 Pro',
            desc_gadget_drone: 'Capturez le monde sous un nouvel angle en 5.1K HDR.',
            prod_gadget_deck: 'Steam Deck OLED 1TB',
            desc_gadget_deck: 'Toute votre bibliothèque Steam dans la paume de votre main.',
            prod_office_desk: 'Bureau Pro Motorisé E7',
            desc_office_desk: 'Ajustement précis pour une posture de travail dynamique.'
        },
        en: {
            store: 'Store',
            admin: 'Admin Dashboard',
            contact: 'Contact Us',
            cart: 'Shopping Cart',
            search_placeholder: 'Search for exceptional hardware...',
            hero_title: 'Technological Excellence',
            hero_subtitle: 'Discover our premium collection of high-performance gear designed for visionaries.',
            cat_all: 'All Products',
            cat_laptops: 'Laptops',
            cat_monitors: 'Monitors',
            cat_audio: 'Audio Gear',
            cat_gadgets: 'AI Gadgets',
            cat_accessories: 'Accessories',
            cat_office: 'Pro Office',
            available: 'In Stock',
            add_to_cart: 'Add to Cart',
            total_label: 'Subtotal',
            checkout_btn: 'Confirm Order',
            order_success_title: 'Order Confirmed',
            order_success_msg: 'Your transaction has been processed successfully.',
            revenue_label: 'Global Revenue',
            total_orders: 'Total Orders',
            platform_status: 'System Status',
            operational: 'Operational',
            recent_orders: 'Recent Transactions',
            cust_details: 'Customer Details',
            purchased_items: 'Purchased Items',
            order_date: 'Purchase Date',
            actions: 'Actions',
            status_pending: 'Pending',
            status_shipped: 'Shipped',
            status_delivered: 'Delivered',
            ship_btn: 'Ship Order',
            deliver_btn: 'Deliver',
            empty_orders: 'No orders recorded yet.',
            contact_name: 'Full Name',
            contact_email: 'Email Address',
            contact_subject: 'Subject',
            contact_msg: 'How can we help you?',
            send_msg: 'Send Message',
            contact_success: 'Your message has been sent to our team.',
            footer_text: 'Premium E-commerce platform powered by Kubernetes and GitOps.',
            close: 'Close',
            items_count: 'items',
            lang_label: 'Language',
            theme_label: 'Theme',
            // Product Translations
            prod_laptop_hp: 'EliteBook Pro X1',
            desc_laptop_hp: 'The pinnacle of mobile productivity for demanding developers.',
            prod_laptop_mbp: 'MacBook Pro M3 Max',
            desc_laptop_mbp: 'Raw power meets absolute Apple elegance.',
            prod_laptop_razer: 'Razer Blade Stealth 16',
            desc_laptop_razer: 'Where thinness meets high-end gaming.',
            prod_mon_5k: 'UltraWide 5K Pro Display',
            desc_mon_5k: 'Total immersion with studio color accuracy.',
            prod_mon_g9: 'Samsung Odyssey Neo G9',
            desc_mon_g9: 'The future of display: 1000R curve and Mini-LED.',
            prod_kb_mx: 'Mechanical MX Pro Keyboard',
            desc_kb_mx: 'Unmatched tactile feel for fast and precise typing.',
            prod_mouse_mx: 'Logitech MX Master 3S Mouse',
            desc_mouse_mx: 'Surgical precision and advanced ergonomics for pros.',
            prod_audio_studio: 'Studio HD-800 Headphones',
            desc_audio_studio: 'Adaptive noise canceling for total focus.',
            prod_audio_pods: 'AirPods Max Graphite',
            desc_audio_pods: 'High-fidelity sound redefined by cutting-edge engineering.',
            prod_gadget_drone: 'DJI Mavic 3 Pro Drone',
            desc_gadget_drone: 'Capture the world from a new perspective in 5.1K HDR.',
            prod_gadget_deck: 'Steam Deck OLED 1TB',
            desc_gadget_deck: 'Your entire Steam library in the palm of your hand.',
            prod_office_desk: 'E7 Motorized Pro Desk',
            desc_office_desk: 'Precise adjustment for dynamic working posture.'
        },
        ar: {
            store: 'المتجر',
            admin: 'لوحة التحكم',
            contact: 'اتصل بنا',
            cart: 'سلة المشتريات',
            search_placeholder: 'ابحث عن أجهزة استثنائية...',
            hero_title: 'التميز التكنولوجي',
            hero_subtitle: 'اكتشف مجموعتنا المتميزة من الأجهزة عالية الأداء المصممة للمبدعين.',
            cat_all: 'جميع المنتجات',
            cat_laptops: 'الحواسيب',
            cat_monitors: 'الشاشات',
            cat_audio: 'الصوتيات',
            cat_gadgets: 'أجهزة ذكية',
            cat_accessories: 'الملحقات',
            cat_office: 'المكتب',
            available: 'متوفر حالياً',
            add_to_cart: 'أضف إلى السلة',
            total_label: 'المجموع الفرعي',
            checkout_btn: 'تأكيد الطلب',
            order_success_title: 'تم تأكيد الطلب',
            order_success_msg: 'تمت معالجة معاملتك بنجاح.',
            revenue_label: 'إجمالي الإيرادات',
            total_orders: 'إجمالي الطلبات',
            platform_status: 'حالة النظام',
            operational: 'يعمل بكفاءة',
            recent_orders: 'أحدث المعاملات',
            cust_details: 'تفاصيل العميل',
            purchased_items: 'الأصناف المشتراة',
            order_date: 'تاريخ الشراء',
            actions: 'الإجراءات',
            status_pending: 'قيد الانتظار',
            status_shipped: 'تم الشحن',
            status_delivered: 'تم التسليم',
            ship_btn: 'شحن الطلب',
            deliver_btn: 'تسليم',
            empty_orders: 'لا توجد طلبات مسجلة حتى الآن.',
            contact_name: 'الاسم بالكامل',
            contact_email: 'البريد الإلكتروني',
            contact_subject: 'الموضوع',
            contact_msg: 'كيف يمكننا مساعدتك؟',
            send_msg: 'إرسال الرسالة',
            contact_success: 'تم إرسال رسالتك إلى فريقنا بنجاح.',
            footer_text: 'منصة تسوق فاخرة مدعومة بتقنيات Kubernetes و GitOps.',
            close: 'إغلاق',
            items_count: 'أصناف',
            lang_label: 'اللغة',
            theme_label: 'الوضع',
            // Product Translations
            prod_laptop_hp: 'EliteBook Pro X1',
            desc_laptop_hp: 'قمة الإنتاجية المحمولة للمبرمجين المحترفين.',
            prod_laptop_mbp: 'MacBook Pro M3 Max',
            desc_laptop_mbp: 'قوة مذهلة تجتمع مع أناقة آبل المطلقة.',
            prod_laptop_razer: 'Razer Blade Stealth 16',
            desc_laptop_razer: 'عندما تلتقي النحافة مع الأداء العالي للألعاب.',
            prod_mon_5k: 'شاشة UltraWide 5K Pro',
            desc_mon_5k: 'انغماس كامل مع دقة ألوان استوديو احترافية.',
            prod_mon_g9: 'Samsung Odyssey Neo G9',
            desc_mon_g9: 'مستقبل الشاشات: انحناء 1000R وتقنية Mini-LED.',
            prod_kb_mx: 'لوحة مفاتيح MX Pro الميكانيكية',
            desc_kb_mx: 'لمسة لا تضاهى للكتابة السريعة والدقيقة.',
            prod_mouse_mx: 'فأرة Logitech MX Master 3S',
            desc_mouse_mx: 'دقة جراحية وتصميم مريح للمحترفين.',
            prod_audio_studio: 'سماعات Studio HD-800',
            desc_audio_studio: 'عزل ضوضاءتكيفي لتركيز كامل.',
            prod_audio_pods: 'AirPods Max Graphite',
            desc_audio_pods: 'إعادة تعريف الصوت عالي الدقة بهندسة متطورة.',
            prod_gadget_drone: 'Mavic 3 Pro Drone',
            desc_gadget_drone: 'التقط العالم من منظور جديد بدقة 5.1K HDR.',
            prod_gadget_deck: 'Steam Deck OLED 1TB',
            desc_gadget_deck: 'مكتبة Steam كاملة بين يديك.',
            prod_office_desk: 'مكتب E7 الكهربائي الاحترافي',
            desc_office_desk: 'تعديل دقيق لوضعية عمل ديناميكية.'
        }
    };

    constructor(private http: HttpClient) { }

    ngOnInit() {
        this.loadProducts();
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
            const matchesCategory = this.currentCategory === 'cat_all' || p.categoryKey === this.currentCategory;
            const matchesSearch = this.t(p.nameKey).toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                this.t(p.descKey).toLowerCase().includes(this.searchQuery.toLowerCase());
            return matchesCategory && matchesSearch;
        });
    }

    get totalRevenue() {
        return this.orders.reduce((acc, o) => acc + o.totalAmount, 0);
    }

    addToCart(product: Product) { this.cart.push(product); }
    removeFromCart(index: number) { this.cart.splice(index, 1); }
    get total() { return this.cart.reduce((sum, p) => sum + p.price, 0); }

    checkout() {
        if (!this.customer.name || !this.customer.email || this.cart.length === 0) return;
        this.lastOrderTotal = this.total;
        const order: Order = {
            customerName: this.customer.name,
            customerEmail: this.customer.email,
            productNames: this.cart.map(p => this.t(p.nameKey)),
            totalAmount: this.lastOrderTotal,
            status: 'PENDING'
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
        if (view === 'admin') this.loadOrders();
    }

    setLanguage(lang: 'fr' | 'en' | 'ar') {
        this.currentLang = lang;
        document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
    }

    toggleTheme() { this.isDarkMode = !this.isDarkMode; }
    toggleCart() { this.isCartOpen = !this.isCartOpen; }
    toggleMobileMenu() { this.isMobileMenuOpen = !this.isMobileMenuOpen; }
}
