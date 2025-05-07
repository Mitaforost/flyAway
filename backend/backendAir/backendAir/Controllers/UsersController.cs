using backendAir.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backendAir.Controllers
{
    [ApiController]
    [Route("users")]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _db;
        public UsersController(AppDbContext db) => _db = db;

        [HttpGet]
        public IActionResult GetAll() => Ok(_db.Users.ToList());

        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            var item = _db.Users.Find(id);
            return item == null ? NotFound() : Ok(item);
        }

        [HttpPost]
        public IActionResult Create(User user)
        {
            _db.Users.Add(user);
            _db.SaveChanges();
            return Ok(user);
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, User updated)
        {
            var user = _db.Users.Find(id);
            if (user == null) return NotFound();

            user.Email = updated.Email;
            user.PasswordHash = updated.PasswordHash;
            user.FullName = updated.FullName;
            user.Phone = updated.Phone;
            _db.SaveChanges();

            return Ok(user);
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var user = _db.Users.Find(id);
            if (user == null) return NotFound();

            _db.Users.Remove(user);
            _db.SaveChanges();
            return Ok();
        }
    }
}
