package com.example.demo.infrastructure.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class StaticResourceConfiguration implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Servir archivos desde el directorio uploads/qr-deuna
        registry.addResourceHandler("/uploads/qr-deuna/**")
                .addResourceLocations("file:uploads/qr-deuna/");
    }
}
