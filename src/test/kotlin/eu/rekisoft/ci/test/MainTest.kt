package eu.rekisoft.ci.test

import org.junit.Test
import kotlin.random.Random

class MainTest {
    @Test
    fun hallo() {
        Thread.sleep(Random(System.currentTimeMillis()).nextLong(0, 2000))
    }
}