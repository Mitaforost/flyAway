using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backendAir.Models
{
    [Table("faq")]
    public class Faq
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("question")]
        public string Question { get; set; }

        [Column("answer")]
        public string Answer { get; set; }
    }
}
