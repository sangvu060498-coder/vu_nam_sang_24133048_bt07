package vn.iotstar.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebViewController {

    @GetMapping({"/", "/admin/category-ajax"})
    public String categoryAjaxPage() {
        return "category-ajax";
    }

    @GetMapping("/admin/product-ajax")
    public String productAjaxPage() {
        return "product-ajax";
    }
}
