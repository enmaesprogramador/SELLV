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
    public interface IProductRepository : IGenericInterface<Product>
    {
        bool ProductExists(Product product);

    }


    public class ProductRepository(SELLVDBContext dbContext) :
        GenericRepository<Product>(dbContext), IProductRepository
    {
        private readonly SELLVDBContext _dbContext = dbContext;


        public override ResultPattern<Product> Post(Product entity)
        {
            if (ProductExists(entity))
                throw new BadRequestException($"A product with the code {entity.Code} already exist. ");


            return base.Post(entity);
        }

        public override ResultPattern<Product> Update(Func<Product, bool> predicate, Product updatedEntity)
        {
            if (ProductExists(updatedEntity))
                throw new BadRequestException($"Can't update this product with the code {updatedEntity.Code} a product with this code already exist. ");

            return base.Update(predicate, updatedEntity);
        }


        public bool ProductExists(Product product)
            => _dbContext.Products.Any(x => x.Code == product.Code);

    }
}
