using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SELLVAPI.DataAccess.Dto
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
