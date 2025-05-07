using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("flights")]
    public class FlightsController : ControllerBase
    {
        private readonly AppDbContext _db;
        public FlightsController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.Flights.ToList());

        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var item = _db.Flights.Find(id);
            if (item == null) return NotFound();
            return Ok(item);
        }

        [HttpPost]
        public IActionResult Create(Flight flight)
        {
            _db.Flights.Add(flight);
            _db.SaveChanges();
            return Ok(flight);
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, Flight updated)
        {
            var flight = _db.Flights.Find(id);
            if (flight == null) return NotFound();

            // Присваиваем поля
            flight.FlightNumber = updated.FlightNumber;
            flight.DepartureAirport = updated.DepartureAirport;
            flight.ArrivalAirport = updated.ArrivalAirport;
            flight.DepartureTime = updated.DepartureTime;
            flight.ArrivalTime = updated.ArrivalTime;
            flight.AircraftModel = updated.AircraftModel;
            flight.Status = updated.Status;

            _db.SaveChanges();
            return Ok(flight);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var flight = _db.Flights.Find(id);
            if (flight == null) return NotFound();

            _db.Flights.Remove(flight);
            _db.SaveChanges();
            return Ok();
        }
    }
}
