using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("loyalty")]
    public class LoyaltyProgramController : ControllerBase
    {
        private readonly AppDbContext _db;
        public LoyaltyProgramController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.LoyaltyPrograms.ToList());

        [HttpPost]
        public IActionResult Create(LoyaltyProgram item)
        {
            _db.LoyaltyPrograms.Add(item);
            _db.SaveChanges();
            return Ok(item);
        }
        [HttpPut("{userId}")]
        public IActionResult Update(int userId, LoyaltyProgram updated)
        {
            var item = _db.LoyaltyPrograms.Find(userId);
            if (item == null) return NotFound();

            item.Points = updated.Points;
            item.Level = updated.Level;
            item.DiscountPercent = updated.DiscountPercent;

            _db.SaveChanges();
            return Ok(item);
        }

        [HttpDelete("{userId}")]
        public IActionResult Delete(int userId)
        {
            var item = _db.LoyaltyPrograms.Find(userId);
            if (item == null) return NotFound();

            _db.LoyaltyPrograms.Remove(item);
            _db.SaveChanges();
            return Ok();
        }
    }
}
