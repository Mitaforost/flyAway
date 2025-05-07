using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("bookings")]
    public class BookingsController : ControllerBase
    {
        private readonly AppDbContext _db;
        public BookingsController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.Bookings.ToList());

        [HttpPost]
        public IActionResult Create([FromBody] Booking booking)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Установите значения по умолчанию, если они не предоставлены
            if (booking.BookingStatus == null)
            {
                booking.BookingStatus = "pending";
            }

            if (booking.Payments == null)
            {
                booking.Payments = new List<Payment>();
            }

            _db.Bookings.Add(booking);
            _db.SaveChanges();

            return Ok(booking);
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, Booking updated)
        {
            var booking = _db.Bookings.Find(id);
            if (booking == null) return NotFound();

            // Проверяем статус бронирования перед обновлением
            if (!new[] { "pending", "active", "cancelled" }.Contains(updated.BookingStatus))
            {
                return BadRequest(new
                {
                    Message = "Invalid BookingStatus. Allowed values are: pending, active, cancelled."
                });
            }

            booking.UserId = updated.UserId;
            booking.FlightId = updated.FlightId;
            booking.SeatId = updated.SeatId;
            booking.BookingStatus = updated.BookingStatus;

            _db.SaveChanges();
            return Ok(booking);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var booking = _db.Bookings.Find(id);
            if (booking == null) return NotFound();

            _db.Bookings.Remove(booking);
            _db.SaveChanges();
            return Ok();
        }
    }
}