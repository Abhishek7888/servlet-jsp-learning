# Servlet Notes - Complete Guide

## Table of Contents
1. [Introduction to Servlets](#introduction-to-servlets)
2. [Servlet Lifecycle](#servlet-lifecycle)
3. [Servlet Container](#servlet-container)
4. [Request and Response](#request-and-response)
5. [Servlet Configuration](#servlet-configuration)
6. [Session Management](#session-management)
7. [Filters](#filters)
8. [Exception Handling](#exception-handling)
9. [Best Practices](#best-practices)

---

## Introduction to Servlets

### What is a Servlet?
- A servlet is a Java class that extends the functionality of servers that host applications accessed by means of a request-response programming model.
- Servlets are used to create dynamic web content.
- They run on the server side and can access Java libraries, databases, and other server resources.

### Key Characteristics
- **Server-side technology**: Runs on the web server
- **Java-based**: Written in Java, compiled to bytecode
- **Platform-independent**: Can run on any platform with JVM
- **Persistent**: Remains in memory after handling first request
- **Scalable**: Can handle multiple client requests concurrently

### Servlet vs JSP
| Aspect | Servlet | JSP |
|--------|---------|-----|
| Compilation | Pre-compiled | Compiled at runtime |
| Syntax | Java code | HTML + Java tags |
| Performance | Slightly faster | Slower initial request |
| Learning Curve | Steeper | Easier for beginners |
| Presentation | Not ideal | Better for UI |

---

## Servlet Lifecycle

The servlet lifecycle consists of several phases:

### 1. **Loading** (Class Loading)
- The servlet container loads the servlet class when the server starts or when the servlet is first requested.
- Uses `ClassLoader` to load the servlet class.

### 2. **Instantiation** (Object Creation)
- Creates an instance of the servlet class using the no-argument constructor.
- Only one instance is created per servlet definition.
- All requests are handled by this single instance (Thread-per-request model).

### 3. **Initialization** (init() method)
```java
public void init(ServletConfig config) throws ServletException {
    super.init(config);
    // Initialize resources
    // Load configuration
    // Connect to database
}
```
- Called only once during the lifetime of the servlet
- Used to initialize resources needed by the servlet
- If initialization fails, `ServletException` is thrown

### 4. **Service** (service() method)
```java
protected void service(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    // Handle request
}
```
- Called for each request
- Determines the HTTP method (GET, POST, PUT, DELETE) and calls appropriate method
- Typically overridden: `doGet()`, `doPost()`, `doPut()`, `doDelete()`

### 5. **Destruction** (destroy() method)
```java
public void destroy() {
    // Clean up resources
    // Close database connections
    // Release file handles
}
```
- Called once when the servlet is being removed from service
- Used to clean up resources
- Called before the servlet instance is garbage collected

### Lifecycle Diagram
```
Server Start
    ↓
Load Servlet Class (ClassLoader)
    ↓
Create Servlet Instance (Constructor)
    ↓
init() - Called Once
    ↓
↓--------service() - Called for Each Request--------↓
↓                                                   ↓
doGet()  doPost()  doPut()  doDelete() ... etc
    ↓
↑--------Response Sent Back to Client---------↑
    ↓
destroy() - Called Once at Server Shutdown
    ↓
Servlet Unloaded
```

---

## Servlet Container

### What is a Servlet Container?
- A component of a web server or application server that interacts with Java servlets.
- Also known as a servlet engine or servlet runner.
- Manages the complete lifecycle of servlets.

### Responsibilities of Servlet Container
1. **Loading**: Load servlet classes
2. **Instantiation**: Create servlet instances
3. **Initialization**: Call init() method
4. **Request Routing**: Route HTTP requests to appropriate servlet
5. **Thread Management**: Create threads for concurrent requests
6. **Session Management**: Manage user sessions
7. **Security**: Enforce security policies
8. **Resource Management**: Manage memory and resources
9. **Destruction**: Call destroy() method

### Popular Servlet Containers
- **Apache Tomcat**: Most popular, open-source
- **Jetty**: Lightweight, embeddable
- **JBoss/WildFly**: Full application server
- **GlassFish**: Reference implementation
- **IBM WebSphere**: Enterprise server
- **Oracle WebLogic**: Enterprise server

---

## Request and Response

### HttpServletRequest
Represents the HTTP request from the client.

#### Key Methods
```java
// Get request information
String method = request.getMethod();                    // GET, POST, etc.
String requestURI = request.getRequestURI();
String queryString = request.getQueryString();
String contextPath = request.getContextPath();

// Get parameters
String name = request.getParameter("name");              // Single value
String[] hobbies = request.getParameterValues("hobby");  // Multiple values
Map<String, String[]> params = request.getParameterMap();

// Get headers
String userAgent = request.getHeader("User-Agent");
Enumeration<String> headerNames = request.getHeaderNames();

// Get cookies
Cookie[] cookies = request.getCookies();

// Get session
HttpSession session = request.getSession();
HttpSession session = request.getSession(false);        // Don't create new

// Get request body (for POST/PUT)
BufferedReader reader = request.getReader();
ServletInputStream input = request.getInputStream();

// Get client information
String remoteAddr = request.getRemoteAddr();
String remoteHost = request.getRemoteHost();
```

### HttpServletResponse
Represents the HTTP response to the client.

#### Key Methods
```java
// Set response status
response.setStatus(HttpServletResponse.SC_OK);           // 200
response.setStatus(HttpServletResponse.SC_NOT_FOUND);    // 404

// Set response headers
response.setContentType("text/html; charset=UTF-8");
response.setHeader("Custom-Header", "value");
response.addHeader("Set-Cookie", "name=value");

// Set content length
response.setContentLength(1024);

// Get output stream
PrintWriter writer = response.getWriter();
ServletOutputStream output = response.getOutputStream();

// Redirect
response.sendRedirect("http://example.com");
response.sendError(HttpServletResponse.SC_NOT_FOUND);

// Send data
writer.println("Hello, World!");
writer.flush();
writer.close();
```

---

## Servlet Configuration

### web.xml Configuration
The `web.xml` file (deployment descriptor) configures servlets and their mappings.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <!-- Servlet Declaration -->
    <servlet>
        <servlet-name>HelloServlet</servlet-name>
        <servlet-class>com.example.HelloServlet</servlet-class>
        
        <!-- Initialization Parameters -->
        <init-param>
            <param-name>author</param-name>
            <param-value>John Doe</param-value>
        </init-param>
        
        <!-- Load on Startup -->
        <load-on-startup>1</load-on-startup>
    </servlet>

    <!-- Servlet Mapping -->
    <servlet-mapping>
        <servlet-name>HelloServlet</servlet-name>
        <url-pattern>/hello</url-pattern>
    </servlet-mapping>

    <!-- Welcome Files -->
    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>

</web-app>
```

### Annotation-based Configuration (Servlet 3.0+)
Modern approach using annotations instead of web.xml.

```java
@WebServlet(
    name = "HelloServlet",
    urlPatterns = {"/hello", "/hi"},
    initParams = {
        @WebInitParam(name = "author", value = "John Doe")
    },
    loadOnStartup = 1
)
public class HelloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>Hello, World!</h1>");
    }
}
```

### Accessing Init Parameters
```java
public void init() throws ServletException {
    // From web.xml
    ServletConfig config = getServletConfig();
    String author = config.getInitParameter("author");
    
    // From ServletContext
    String dbUrl = getServletContext().getInitParameter("database.url");
}
```

---

## Session Management

### What is a Session?
- A session represents a conversation between a client and server.
- Persists state information across multiple requests.
- Each user has a unique session ID.
- Sessions are time-limited and can expire.

### HttpSession Interface
```java
public void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    
    // Get or create session
    HttpSession session = request.getSession();           // Creates if not exists
    HttpSession session = request.getSession(false);      // Returns null if not exists
    
    // Store data in session
    session.setAttribute("username", "john");
    session.setAttribute("cart", cartObject);
    
    // Retrieve data from session
    String username = (String) session.getAttribute("username");
    
    // Remove data from session
    session.removeAttribute("username");
    
    // Get session information
    String sessionId = session.getId();
    long creationTime = session.getCreationTime();
    long lastAccessedTime = session.getLastAccessedTime();
    int maxInactiveInterval = session.getMaxInactiveInterval();
    
    // Set session timeout (in seconds)
    session.setMaxInactiveInterval(1800);  // 30 minutes
    
    // Get all attribute names
    Enumeration<String> names = session.getAttributeNames();
    
    // Invalidate session
    session.invalidate();
}
```

### Session Tracking Methods
1. **Cookies** (Default)
   - Session ID stored in browser cookie
   - Automatically managed by container
   - Lost when browser closes (unless persistent)

2. **URL Rewriting**
   - Session ID appended to URL as query parameter
   - Used when cookies are disabled
   - Example: `/app/page.jsp;jsessionid=ABC123`

3. **SSL Session**
   - Session tracking through SSL connections

### Session Configuration in web.xml
```xml
<session-config>
    <cookie-config>
        <name>SESSIONID</name>
        <domain>example.com</domain>
        <path>/</path>
        <secure>true</secure>
        <http-only>true</http-only>
    </cookie-config>
    <tracking-mode>COOKIE</tracking-mode>
    <timeout>30</timeout>  <!-- in minutes -->
</session-config>
```

---

## Filters

### What is a Filter?
- A filter is a reusable component that transforms the request/response.
- Filters intercept requests before they reach servlets.
- Multiple filters can be chained together.
- Used for authentication, logging, compression, encryption, etc.

### Filter Interface
```java
public interface Filter {
    void init(FilterConfig config) throws ServletException;
    void doFilter(ServletRequest request, ServletResponse response, 
                  FilterChain chain) throws ServletException, IOException;
    void destroy();
}
```

### Creating a Custom Filter
```java
@WebFilter(urlPatterns = "/*")
public class LoggingFilter implements Filter {
    
    public void init(FilterConfig config) throws ServletException {
        // Initialize filter
    }
    
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws ServletException, IOException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        System.out.println("Request: " + httpRequest.getRequestURI());
        long startTime = System.currentTimeMillis();
        
        // Pass control to next filter or servlet
        chain.doFilter(request, response);
        
        long duration = System.currentTimeMillis() - startTime;
        System.out.println("Response Time: " + duration + " ms");
    }
    
    public void destroy() {
        // Cleanup
    }
}
```

### Filter Configuration in web.xml
```xml
<filter>
    <filter-name>LoggingFilter</filter-name>
    <filter-class>com.example.LoggingFilter</filter-class>
    <init-param>
        <param-name>log-level</param-name>
        <param-value>DEBUG</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>LoggingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

### Common Filter Use Cases
1. **Authentication Filter** - Check user credentials
2. **Logging Filter** - Log all requests and responses
3. **Compression Filter** - Compress response data
4. **Caching Filter** - Cache static content
5. **Security Filter** - Prevent XSS and SQL injection
6. **Character Encoding Filter** - Set request/response encoding

---

## Exception Handling

### Throwing Exceptions from Servlets
```java
public void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    
    try {
        // Some operation
        throw new IOException("File not found");
    } catch (IOException e) {
        throw new ServletException("Servlet error", e);
    }
}
```

### Error Configuration in web.xml
```xml
<!-- Error Page for Specific Exception -->
<error-page>
    <exception-type>java.io.IOException</exception-type>
    <location>/error.jsp</location>
</error-page>

<!-- Error Page for HTTP Status Code -->
<error-page>
    <error-code>404</error-code>
    <location>/page-not-found.jsp</location>
</error-page>

<error-page>
    <error-code>500</error-code>
    <location>/server-error.jsp</location>
</error-page>
```

### Error Attributes in Error Page
```java
// In error.jsp
<%
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
    String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
%>

Error Code: <%= statusCode %>
Message: <%= throwable.getMessage() %>
URI: <%= requestUri %>
```

---

## Best Practices

### 1. **Security**
- Always validate and sanitize user input
- Use parameterized queries to prevent SQL injection
- Implement proper authentication and authorization
- Use HTTPS for sensitive data
- Set HttpOnly and Secure flags on cookies
- Prevent CSRF attacks with tokens
- Keep libraries and frameworks updated

### 2. **Performance**
- Reuse database connections (connection pooling)
- Cache frequently accessed data
- Minimize database queries
- Use compression for response data
- Implement pagination for large datasets
- Use async processing for long-running tasks
- Profile and optimize bottlenecks

### 3. **Scalability**
- Use session replication in clustered environments
- Avoid storing large objects in sessions
- Use distributed caching (Redis, Memcached)
- Implement proper logging and monitoring
- Use load balancing
- Design stateless servlets when possible

### 4. **Code Quality**
```java
// Good: Clear naming and structure
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        String userId = request.getParameter("id");
        if (userId != null && !userId.isEmpty()) {
            User user = userService.getUserById(userId);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user-detail.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID required");
        }
    }
}
```

### 5. **Error Handling**
- Catch specific exceptions, not generic Exception
- Log errors with sufficient context
- Return appropriate HTTP status codes
- Provide meaningful error messages to users
- Don't expose sensitive information in error messages

### 6. **Resource Management**
```java
// Use try-with-resources for automatic closing
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    try (PrintWriter out = response.getWriter()) {
        out.println("Hello, World!");
    } catch (IOException e) {
        // Handle exception
    }
}
```

### 7. **Dependency Injection**
```java
@WebServlet("/users")
public class UserServlet extends HttpServlet {
    @Inject
    private UserService userService;
    
    // Use injected service
}
```

### 8. **Testing**
- Create unit tests for business logic
- Use mock objects for dependencies
- Test servlet methods separately
- Test error conditions and edge cases
- Use tools like JUnit, Mockito, etc.

---

## Summary

Servlets are fundamental to Java web development. Key points:
- **Single Instance, Multiple Requests**: One servlet handles many concurrent requests
- **Lifecycle Management**: Init → Service → Destroy
- **Thread-Safe Code**: Write thread-safe servlet methods
- **Request/Response Handling**: Use HttpServletRequest and HttpServletResponse
- **Session Management**: Use HttpSession for stateful applications
- **Filters**: Intercept requests for cross-cutting concerns
- **Best Practices**: Security, performance, scalability, and code quality matter

For modern applications, consider using frameworks like Spring, Quarkus, or Jakarta EE which simplify servlet development.

---

## Resources

- [Jakarta Servlet Specification](https://jakarta.ee/specifications/servlet/)
- [Apache Tomcat Documentation](https://tomcat.apache.org/tomcat-9.0-doc/)
- [Oracle Java EE Tutorials](https://docs.oracle.com/javaee/)
- [Java Servlet Official API Docs](https://docs.oracle.com/javaee/7/api/javax/servlet/package-summary.html)
