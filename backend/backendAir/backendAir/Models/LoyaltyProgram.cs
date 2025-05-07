using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backendAir.Models
{
    [Table("loyalty_program")]
    public class LoyaltyProgram
    {
        [Key]
        [Column("user_id")]
        public int UserId { get; set; }

        [Column("points")]
        public int Points { get; set; }

        [Column("level")]
        public string Level { get; set; }

        [Column("discount_percent")]
        public decimal DiscountPercent { get; set; }
    }
}
