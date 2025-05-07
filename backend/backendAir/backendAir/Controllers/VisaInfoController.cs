using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("visainfo")]
    public class VisaInfoController : ControllerBase
    {
        private readonly AppDbContext _db;
        public VisaInfoController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.VisaInfos.ToList());

        [HttpPost]
        public IActionResult Create(VisaInfo info)
        {
            _db.VisaInfos.Add(info);
            _db.SaveChanges();
            return Ok(info);
        }
        [HttpPut("{id}")]
        public IActionResult Update(int id, VisaInfo updated)
        {
            var visa = _db.VisaInfos.Find(id);
            if (visa == null) return NotFound();

            visa.Country = updated.Country;
            visa.RequiredDocuments = updated.RequiredDocuments;

            _db.SaveChanges();
            return Ok(visa);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var visa = _db.VisaInfos.Find(id);
            if (visa == null) return NotFound();

            _db.VisaInfos.Remove(visa);
            _db.SaveChanges();
            return Ok();
        }
    }
}
