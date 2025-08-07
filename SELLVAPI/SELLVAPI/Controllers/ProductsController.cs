using Gridify;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SELLVAPI.DataAccess.Models;
using SELLVAPI.DataAccess.Repository;
using SELLVAPI.Utils.ResponseObjects;

namespace SELLVAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly IProductRepository _productRepository;
        public ProductsController(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }
        [HttpGet]
        public ActionResult<ResultPattern<Paging<Product>>> GetProducts([FromQuery] GridifyQuery query)
            => Ok(_productRepository.GetAll(query));

        [HttpGet("{id:int}")]
        public ActionResult<ResultPattern<Product>> GetProduct(int id)
            => Ok(_productRepository.Get(x => x.Id == id));

        [HttpPost, Authorize]
        public ActionResult<ResultPattern<Product>> CreateProduct([FromBody] Product product)
            => Created(string.Empty, _productRepository.Post(product));

        [HttpPut]
        public ActionResult<ResultPattern<Product>> UpdateProduct(int id, [FromBody] Product product)
            => Ok(_productRepository.Update(x => x.Id == id, product));
    }
}
