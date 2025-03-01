package com.demo.ServiceA.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/service-a")
public class ServiceAController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Service A! New Version 1.1.1.2";
    }
}
