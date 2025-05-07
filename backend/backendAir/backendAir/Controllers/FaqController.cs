using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("faq")]
    public class FaqController : ControllerBase
    {
        private readonly AppDbContext _db;
        public FaqController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.Faqs.ToList());

        [HttpPost]
        public IActionResult Create(Faq faq)
        {
            _db.Faqs.Add(faq);
            _db.SaveChanges();
            return Ok(faq);
        }
        [HttpPut("{id}")]
        public IActionResult Update(int id, Faq updated)
        {
            var faq = _db.Faqs.Find(id);
            if (faq == null) return NotFound();

            faq.Question = updated.Question;
            faq.Answer = updated.Answer;

            _db.SaveChanges();
            return Ok(faq);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var faq = _db.Faqs.Find(id);
            if (faq == null) return NotFound();

            _db.Faqs.Remove(faq);
            _db.SaveChanges();
            return Ok();
        }
    }
}
