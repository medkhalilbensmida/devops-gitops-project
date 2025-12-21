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
    currentView: 'shop' | 'admin' = 'shop';
    currentCategory = 'All';
    searchQuery = '';

    customer = {
        name: '',
        email: ''
    };

    categories = ['All', 'Laptops', 'Monitors', 'Audio', 'Gadgets', 'Accessories', 'Office'];

    constructor(private http: HttpClient) { }

    ngOnInit() {
        this.loadProducts();
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

        const order: Order = {
            customerName: this.customer.name,
            customerEmail: this.customer.email,
            productNames: this.cart.map(p => p.name),
            totalAmount: this.total
        };

        this.http.post('/api/orders', order).subscribe({
            next: () => {
                this.orderPlaced = true;
                this.cart = [];
                this.isCartOpen = false;
                setTimeout(() => this.orderPlaced = false, 5000);
            }
        });
    }

    updateOrderStatus(orderId: number, status: string) {
        this.http.put(`/api/orders/${orderId}/status`, { status }).subscribe({
            next: () => this.loadOrders()
        });
    }

    switchView(view: 'shop' | 'admin') {
        this.currentView = view;
        if (view === 'admin') {
            this.loadOrders();
        }
    }

    toggleCart() {
        this.isCartOpen = !this.isCartOpen;
    }
}
