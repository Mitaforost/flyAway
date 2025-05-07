using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backendAir.Models
{
    [Table("bookings")]
    public class Booking
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("user_id")]
        public int UserId { get; set; }

        [Column("flight_id")]
        public int FlightId { get; set; }

        [Column("seat_id")]
        public int SeatId { get; set; }

        [Column("booking_status")]
        public string BookingStatus { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        // Навигационное свойство для связи с платежами
        public ICollection<Payment> Payments { get; set; }
    }
}