using System.ComponentModel.DataAnnotations;

namespace POS_VET_API.DataAccess.DTOs
{
    public class UserRegistrationDto
    {
        [Required] public string FullName { get; set; } = null!;
        [Required] public string Username { get; set; } = null!;
        [Required] public string Password { get; set; } = null!;
        public string? PhoneNumber { get; set; } = null!;
        public DateTime? BirthDate { get; set; }
        public string? FullDirection { get; set; } = null!;
        public int? CompanyId { get; set; }
        public int? CreatedBy { get; set; }
        public int? UpdatedBy { get; set; }
    }
}