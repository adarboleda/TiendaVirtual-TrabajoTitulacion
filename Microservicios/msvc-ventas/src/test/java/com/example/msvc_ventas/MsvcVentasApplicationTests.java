package com.example.msvc_ventas;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test") // Usar H2 en lugar de MySQL
class MsvcVentasApplicationTests {

	@Test
	void contextLoads() {
	}

}
