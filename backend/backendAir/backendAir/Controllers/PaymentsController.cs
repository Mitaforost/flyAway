using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("payments")]
    public class PaymentsController : ControllerBase
    {
        private readonly AppDbContext _db;
        public PaymentsController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.Payments.ToList());

        [HttpPost]
        public IActionResult Create([FromBody] PaymentCreateDto paymentDto)
        {
            try
            {
                // Проверка существования брони
                var booking = _db.Bookings.Find(paymentDto.BookingId);
                if (booking == null)
                {
                    return BadRequest(new { Message = $"Booking with id {paymentDto.BookingId} not found" });
                }

                // Разрешить платежи для бронирований со статусом "pending" и "active"
                if (booking.BookingStatus != "pending" && booking.BookingStatus != "active")
                {
                    return BadRequest(new { Message = "Booking must be pending or active to accept payments" });
                }

                // Если статус "pending", обновляем его на "active"
                if (booking.BookingStatus == "pending")
                {
                    booking.BookingStatus = "active";
                }

                // Создаем платеж из DTO
                var payment = new Payment
                {
                    BookingId = paymentDto.BookingId,
                    PaymentMethodId = paymentDto.PaymentMethodId,
                    Amount = paymentDto.Amount,
                    Status = paymentDto.Status ?? "completed",
                    PaymentTime = paymentDto.PaymentTime ?? DateTime.UtcNow
                };

                _db.Payments.Add(payment);
                _db.SaveChanges();

                return Ok(payment);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    Message = "Payment creation failed",
                    Error = ex.Message
                });
            }
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, Payment updated)
        {
            var payment = _db.Payments.Find(id);
            if (payment == null) return NotFound();

            payment.BookingId = updated.BookingId;
            payment.PaymentMethodId = updated.PaymentMethodId;
            payment.Amount = updated.Amount;
            payment.Status = updated.Status;

            _db.SaveChanges();
            return Ok(payment);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var payment = _db.Payments.Find(id);
            if (payment == null) return NotFound();

            _db.Payments.Remove(payment);
            _db.SaveChanges();
            return Ok();
        }
    }
}
