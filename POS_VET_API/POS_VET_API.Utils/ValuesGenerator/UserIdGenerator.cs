using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.ValueGeneration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace POS_VET_API.Utils.ValuesGenerator
{
    public class UserIdGenerator : ValueGenerator<int>
    {
        public override bool GeneratesTemporaryValues =>
            false;
        public override int Next(EntityEntry entry) =>
            Convert.ToInt32(
            entry.Context
            .GetService<IHttpContextAccessor>()?
            .HttpContext?
            .User?
            .FindFirst("UserId")!
            .Value);
    }
}
