package io.azure.monitoring.javaruntime.springboot;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@SpringBootTest(webEnvironment = WebEnvironment.DEFINED_PORT, properties = {
    "server.port=8803",
    "spring.datasource.url=jdbc:tc:postgresql:14-alpine://testcontainers/postgres",
    "spring.datasource.username=postgres",
    "spring.datasource.password=password"
})
class SpringbootResourceTest {

    private static String basePath = "http://localhost:8803/springboot";

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testHelloEndpoint() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath, String.class);

        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody()).contains("Spring Boot: hello");
    }

    @Test
    public void testLoadEndpointWithDefault() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/load", String.class);

        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody())
            .startsWith("Spring Boot: load: 1 Cpu Iterations - 1 Memory Bites - DB false - LLM false")
            .endsWith("nano-seconds.");
    }

    @Test
    public void testLoadEndpointOverrideCPUandMemory() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/load?cpu=10&memory=20", String.class);

        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody())
            .startsWith("Spring Boot: load: 10 Cpu Iterations - 20 Memory Bites - DB false - LLM false")
            .endsWith("nano-seconds.");
    }

    @Test
    public void testLoadEndpointWithDB() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/load?db=true", String.class);

        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody())
            .startsWith("Spring Boot: load: 1 Cpu Iterations - 1 Memory Bites - DB true - LLM false")
            .contains("The result is persisted in the database.")
            .endsWith("nano-seconds.");
    }

    @Test
    public void testLoadEndpointWithLLM() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/load?llm=true", String.class);

        assertEquals(response.getStatusCode(), HttpStatus.OK);
        assertThat(response.getBody())
            .startsWith("Spring Boot: load: 1 Cpu Iterations - 1 Memory Bites - DB false - LLM true")
            .contains("The prompt has been received from the LLM")
            .endsWith("nano-seconds.");
    }

    @Test
    public void testStats() {
        ResponseEntity<String> response = this.restTemplate.
            getForEntity(basePath + "/stats", String.class);

        assertEquals(response.getStatusCode(), HttpStatus.OK);
    }
}
