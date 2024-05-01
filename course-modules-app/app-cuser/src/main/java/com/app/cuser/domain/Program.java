package com.app.cuser.domain;

import lombok.Data;
import org.springframework.stereotype.Repository;

@Repository
@Data
public class Program {
    private String calendarId;
    private Integer userId;
    private String title;
}
