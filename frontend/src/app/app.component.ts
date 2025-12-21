import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

interface Product {
    id: number;
    name: string;
    description: string;
    price: number;
    imageUrl: string;
}

interface Order {
    customerName: string;
    customerEmail: string;
    productNames: string[];
    totalAmount: number;
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
    cart: Product[] = [];
    isCartOpen = false;
    orderPlaced = false;

    customer = {
        name: '',
        email: ''
    };

    constructor(private http: HttpClient) { }

    ngOnInit() {
        this.loadProducts();
    }

    loadProducts() {
        this.http.get<Product[]>('/api/products').subscribe({
            next: (data) => this.products = data,
            error: (err) => console.error('Error loading products', err)
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

    toggleCart() {
        this.isCartOpen = !this.isCartOpen;
    }
}
