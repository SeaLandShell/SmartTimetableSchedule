//package com.course.gateway.config;
//
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.web.cors.CorsConfiguration;
//import org.springframework.web.cors.reactive.CorsWebFilter;
//import org.springframework.web.util.pattern.PathPatternParser;
//
//@Configuration
//public class CorsConfig {
//
//    @Bean
//    public CorsWebFilter corsFilter() {
//        CorsConfiguration corsConfig = new CorsConfiguration();
//        corsConfig.setAllowCredentials(true);
//        corsConfig.addAllowedOrigin("*");
//        corsConfig.addAllowedHeader("*");
//        corsConfig.addAllowedMethod("*");
//
//        org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource source =
//                new org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource(new PathPatternParser());
//        source.registerCorsConfiguration("/**", corsConfig);
//
//        return new CorsWebFilter(source);
//    }
//}
