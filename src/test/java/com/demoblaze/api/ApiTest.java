package com.demoblaze.api;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ApiTest {

    @Test
    void testAll() {
        Results results = Runner.path("classpath:features/auth").parallel(1);
        assertTrue(results.getScenariosTotal() > 0, "El filtro no seleccionó escenarios");
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
