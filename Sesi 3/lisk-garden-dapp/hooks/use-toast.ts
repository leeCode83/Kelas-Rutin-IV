"use client"

import { toast as sonnerToast } from "sonner"

// Definisi properti dasar untuk toast, sesuai dengan kebutuhan dari GardenGrid.
// Properti ini mereplikasi interface dari useToast shadcn yang lama.
interface ToastProps {
    title: string
    description?: string
    // Anda dapat menambahkan properti lain di sini, seperti 'variant' 
    // untuk menampilkan tipe toast yang berbeda (success, error, dll.)
}

/**
 * Hook kustom untuk menampilkan notifikasi toast menggunakan Sonner.
 * Ini menyediakan API yang konsisten dengan hook useToast shadcn/ui yang lama.
 */
export function useToast() {
    const toast = (props: ToastProps) => {
        // Memetakan argumen 'title' dan 'description' ke API Sonner:
        // title menjadi konten utama, dan description menjadi opsi description.
        sonnerToast(props.title, {
            description: props.description,
            // Jika Anda memiliki variant, Anda bisa menggunakan sonnerToast.success, sonnerToast.error, dll.
            // Contoh: if (props.variant === 'success') { sonnerToast.success(...) } else { sonnerToast(...) }
        })
    }

    return { toast }
}
