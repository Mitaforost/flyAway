using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backendAir.Models
{
    [Table("visa_info")]
    public class VisaInfo
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("country")]
        public string Country { get; set; }

        [Column("required_documents")]
        public string RequiredDocuments { get; set; }
    }
}
