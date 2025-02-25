package io.azure.monitoring.javaruntime.springboot;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfiguration.class)
@SpringBootTest
class SpringbootApplicationTests {

	@Test
	void contextLoads() {
	}

}
