package tags;

import java.io.IOException;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.TagSupport;

public class PrintTable extends TagSupport {

    private int number = 1;   // default value
    private int limit = 10;   // new attribute: how far to print

    // Setter for 'number' attribute
    public void setNumber(int number) {
        this.number = number;
    }

    // Setter for 'limit' attribute (optional)
    public void setLimit(int limit) {
        this.limit = limit;
    }

    @Override
    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            out.println("<table border='1' style='border-collapse:collapse;'>");
            out.println("<tr><th>Multiplier</th><th>Result</th></tr>");
            for (int i = 1; i <= limit; i++) {
                out.println("<tr>");
                out.println("<td>" + i + "</td>");
                out.println("<td>" + (i * number) + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (IOException e) {
            throw new JspException("Error in PrintTable tag", e);
        }
        return SKIP_BODY;
    }
}
