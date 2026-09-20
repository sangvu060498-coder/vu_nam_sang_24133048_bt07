package vn.iotstar.service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import vn.iotstar.entity.Product;

public interface IProductService {
    List<Product> findAll();
    Optional<Product> findById(Long id);
    Optional<Product> findByProductName(String name);
    Optional<Product> findByCreateDate(Date createDate);
    Product save(Product entity);
    void deleteById(Long id);
}
