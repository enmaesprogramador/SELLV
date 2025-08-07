using SELLVAPI.DataAccess.Models;
using SELLVAPI.Utils.Exceptions;
using SELLVAPI.Utils.ResponseObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SELLVAPI.DataAccess.Repository
{
    public interface ICompanyRepository : IGenericInterface<Company>
    {
        bool IsCompanyRncUnique(string rnc);
        bool IsCompanyNameUnique(string name);
    }

    public class CompanyRepository(SELLVDBContext context) :
        GenericRepository<Company>(context), ICompanyRepository
    {
        private readonly SELLVDBContext _context = context;

        public override ResultPattern<Company> Post(Company entity)
        {
            if (IsCompanyNameUnique(entity.Name))
                throw new BadRequestException("An Company with this name exists. ");

            if (IsCompanyRncUnique(entity.FiscalId!))
                throw new BadRequestException("An Company with this fiscal id exists. ");

            return base.Post(entity);
        }

        public bool IsCompanyNameUnique(string name)
        {
            return _context
                .Companies
                .Any(x => x.Name == name);
        }

        public bool IsCompanyRncUnique(string rnc)
        {
            return _context
                .Companies
                .Any(x => x.FiscalId == rnc);
        }
    }
}
