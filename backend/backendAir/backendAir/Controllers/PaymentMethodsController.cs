using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("paymentmethods")]
    public class PaymentMethodsController : ControllerBase
    {
        private readonly AppDbContext _db;
        public PaymentMethodsController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.PaymentMethods.ToList());

        [HttpPost]
        public IActionResult Create(PaymentMethod method)
        {
            _db.PaymentMethods.Add(method);
            _db.SaveChanges();
            return Ok(method);
        }
        [HttpPut("{id}")]
        public IActionResult Update(int id, PaymentMethod updated)
        {
            var method = _db.PaymentMethods.Find(id);
            if (method == null) return NotFound();

            method.Name = updated.Name;

            _db.SaveChanges();
            return Ok(method);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var method = _db.PaymentMethods.Find(id);
            if (method == null) return NotFound();

            _db.PaymentMethods.Remove(method);
            _db.SaveChanges();
            return Ok();
        }
    }
}
