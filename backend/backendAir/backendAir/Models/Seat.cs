using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backendAir.Models
{
    [Table("seats")]
    public class Seat
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("flight_id")]
        public int? FlightId { get; set; } // Сделано необязательным

        [Column("seat_number")]
        public string? SeatNumber { get; set; } // Сделано необязательным

        [Column("is_reserved")]
        public bool? IsReserved { get; set; } // Сделано необязательным

        [Column("price")]
        public decimal? Price { get; set; } // Сделано необязательным
    }
}