using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("seats")]
    public class SeatsController : ControllerBase
    {
        private readonly AppDbContext _db;
        public SeatsController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.Seats.ToList());
        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var seat = _db.Seats.Find(id);
            if (seat == null)
            {
                return NotFound(new { Message = $"Seat with id {id} not found" });
            }
            return Ok(seat);
        }

        [HttpPost]
        public IActionResult Create(Seat seat)
        {
            _db.Seats.Add(seat);
            _db.SaveChanges();
            return Ok(seat);
        }
        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] Seat updated)
        {
            var seat = _db.Seats.Find(id);
            if (seat == null)
            {
                return NotFound(new { Message = $"Seat with id {id} not found" });
            }

            // Обновляем только переданные поля
            if (updated.IsReserved != null)
            {
                seat.IsReserved = updated.IsReserved;
            }

            if (!string.IsNullOrEmpty(updated.SeatNumber))
            {
                seat.SeatNumber = updated.SeatNumber;
            }

            if (updated.FlightId > 0)
            {
                seat.FlightId = updated.FlightId;
            }

            if (updated.Price > 0)
            {
                seat.Price = updated.Price;
            }

            _db.SaveChanges();
            return Ok(seat);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var seat = _db.Seats.Find(id);
            if (seat == null) return NotFound();

            _db.Seats.Remove(seat);
            _db.SaveChanges();
            return Ok();
        }

    }
}
