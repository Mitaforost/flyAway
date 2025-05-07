using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backendAir.Models
{
    [Table("flights")]
    public class Flight
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("flight_number")]
        public string FlightNumber { get; set; }

        [Column("departure_airport")]
        public string DepartureAirport { get; set; }

        [Column("arrival_airport")]
        public string ArrivalAirport { get; set; }

        [Column("departure_time")]
        public DateTime DepartureTime { get; set; }

        [Column("arrival_time")]
        public DateTime ArrivalTime { get; set; }

        [Column("aircraft_model")]
        public string AircraftModel { get; set; }

        [Column("status")]
        public string Status { get; set; }
    }
}
