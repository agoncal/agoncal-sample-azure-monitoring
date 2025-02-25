package io.azure.monitoring.javaruntime.quarkus;

import io.quarkus.test.junit.QuarkusTest;
import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.endsWith;
import static org.hamcrest.Matchers.startsWith;
import org.junit.jupiter.api.Test;

@QuarkusTest
class QuarkusResourceTest {
    @Test
    void testHelloEndpoint() {
        given()
            .when().get("/quarkus")
            .then()
            .statusCode(200)
            .body(is("Quarkus: hello"));
    }

    @Test
    void testLoadEndpointWithDefault() {
        given()
            .when().get("/quarkus/load")
            .then()
            .statusCode(200)
            .body(startsWith("Quarkus: load: 1 Cpu Iterations - 1 Memory Bites - DB false - LLM false"))
            .body(endsWith("nano-seconds."));
    }

    @Test
    void testLoadEndpointOverrideCPUandMemory() {
        given().param("cpu", 10).param("memory", 20)
            .when().get("/quarkus/load")
            .then()
            .statusCode(200)
            .body(startsWith("Quarkus: load: 10 Cpu Iterations - 20 Memory Bites - DB false - LLM false"))
            .body(endsWith("nano-seconds."));
    }

    @Test
    void testLoadEndpointWithDB() {
        given().param("db", true)
            .when().get("/quarkus/load")
            .then()
            .statusCode(200)
            .body(startsWith("Quarkus: load: 1 Cpu Iterations - 1 Memory Bites - DB true - LLM false"))
            .body(containsString("The result is persisted in the database."))
            .body(endsWith("nano-seconds."));
    }


    @Test
    void testLoadEndpointWithLLM() {
        given().param("llm", true)
            .when().get("/quarkus/load")
            .then()
            .statusCode(200)
            .body(startsWith("Quarkus: load: 1 Cpu Iterations - 1 Memory Bites - DB false - LLM true"))
            .body(containsString("The prompt has been received from the LLM"))
            .body(endsWith("nano-seconds."));
    }

    @Test
    void testStats() {
        given()
            .when().get("/quarkus/stats")
            .then()
            .statusCode(200);
    }
}
