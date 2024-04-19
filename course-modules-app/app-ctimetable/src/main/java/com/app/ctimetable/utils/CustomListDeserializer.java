package com.app.ctimetable.utils;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CustomListDeserializer extends JsonDeserializer<List<String>> {

    @Override
    public List<String> deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) throws IOException {
        List<String> list = new ArrayList<>();
        while (jsonParser.nextToken() != null) {
            String value = jsonParser.getValueAsString();
            list.add(value);
        }
        return list;
    }
}
