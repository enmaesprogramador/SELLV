using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SELLVAPI.Utils.ResponseObjects
{
    public record ResultPattern<T>
    {
        //public ResultPattern(T data, int statusCode, bool isSuccess, string message)
        //{
        //    Data = data;
        //    StatusCode = statusCode;
        //    IsSuccess = isSuccess;
        //    Message = message;
        //}
        public T? Data { get; init; }
        public int? StatusCode { get; init; }
        public bool? IsSuccess { get; init; }
        public string? Message { get; init; }
        public static ResultPattern<T> Success(
            T data,
            int statusCode,
            string message) =>
            new ResultPattern<T>
            {
                Data = data,
                StatusCode = statusCode,
                IsSuccess = true,
                Message = message
            };
        public static ResultPattern<T> Failure(int statuscode, string message, T? data = default) =>
            new ResultPattern<T>
            {
                Data = data,
                StatusCode = statuscode,
                IsSuccess = false,
                Message = message
            };
    }
}
