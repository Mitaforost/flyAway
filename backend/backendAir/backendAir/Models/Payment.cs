using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backendAir.Models
{
    [Table("payments")]
    public class Payment
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("booking_id")]
        [ForeignKey("Booking")]
        public int BookingId { get; set; }

        [Required]
        [Column("payment_method_id")]
        public int PaymentMethodId { get; set; }

        [Required]
        [Column("amount")]
        public decimal Amount { get; set; }

        [Column("payment_time")]
        public DateTime PaymentTime { get; set; } = DateTime.UtcNow;

        [Required]
        [Column("status")]
        public string Status { get; set; } = "pending";

        // Навигационное свойство
        public Booking? Booking { get; set; }
    }

    // Добавьте этот класс в Models
    public class PaymentCreateDto
    {
        public int BookingId { get; set; }
        public int PaymentMethodId { get; set; }
        public decimal Amount { get; set; }
        public string? Status { get; set; }
        public DateTime? PaymentTime { get; set; }
    }
}