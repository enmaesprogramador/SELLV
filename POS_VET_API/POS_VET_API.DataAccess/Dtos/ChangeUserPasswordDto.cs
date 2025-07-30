using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_VET_API.DataAccess.DTOs
{
    public class ChangeUserPasswordDto
    {
        [Required] public string Password { get; set; }
    }
}
