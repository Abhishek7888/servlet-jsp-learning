# Servlet Notes - Complete Guide

## Table of Contents
1. [Introduction to Servlets](#introduction-to-servlets)
2. [Servlet Lifecycle](#servlet-lifecycle)
3. [Servlet Container](#servlet-container)
4. [Request and Response](#request-and-response)
5. [Servlet Configuration](#servlet-configuration)
6. [Session Management](#session-management)
7. [Session Tracking in Servlet](#session-tracking-in-servlet)
8. [Filters](#filters)
9. [Exception Handling](#exception-handling)
10. [Internal Working of Servlet](#internal-working-of-servlet)
11. [Deployment Descriptor](#deployment-descriptor)
12. [Parameters and Attributes in Servlet](#parameters-and-attributes-in-servlet)
13. [RequestDispatcher](#requestdispatcher)
14. [Welcome Files and Resource Mapping](#welcome-files-and-resource-mapping)
15. [Best Practices](#best-practices)

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

## Session Tracking in Servlet

### What is Session Tracking?

**Session Tracking** is a way to maintain state (data) of a user. It is also known as **State Management**.

- Enables servlets to recognize returning users
- Maintains user-specific data across multiple requests
- Essential for e-commerce, authentication, and personalized experiences
- Allows sharing of user information between different servlets

### Session Tracking Flow

```
HTTP (Stateless)
    ↓
    ├─ Browser sends request with session ID
    │
    ├─ Server recognizes returning user
    │
    └─ Each request identified as new request
        with new session ID
```

The server-side mechanism:
1. **First Request**: Client makes a request → Browser creates new session
2. **Server Processing**: Server creates session object for the user
3. **Session Persistence**: Server stores session data with unique ID
4. **Subsequent Requests**: Client sends session ID with each request
5. **Data Retrieval**: Server retrieves session data using session ID

---

### Session Tracking Techniques

There are **four techniques** used in Session Tracking:

#### 1. **Cookies**
- Session ID stored in browser cookie
- Automatically sent with each request
- Most common and default method
- Works seamlessly with HttpSession API

```java
// Setting a cookie
Cookie sessionCookie = new Cookie("JSESSIONID", "ABC123XYZ");
sessionCookie.setMaxAge(1800);  // 30 minutes
response.addCookie(sessionCookie);

// Retrieving cookies
Cookie[] cookies = request.getCookies();
for (Cookie cookie : cookies) {
    if ("JSESSIONID".equals(cookie.getName())) {
        String sessionId = cookie.getValue();
    }
}
```

**Advantages:**
- Simple and automatic
- Works with HttpSession
- Widely supported

**Disadvantages:**
- Can be disabled in browser
- User can delete cookies
- Storage limitations

#### 2. **Hidden Form Field**
- Session ID passed as hidden form field
- Embedded in HTML form
- Manual management required
- Alternative when cookies disabled

```html
<!-- HTML Form with hidden field -->
<form method="POST" action="/nextServlet">
    <input type="hidden" name="jsessionid" value="ABC123XYZ">
    <input type="text" name="username">
    <input type="submit">
</form>
```

```java
// Retrieving session ID from hidden field
String sessionId = request.getParameter("jsessionid");
```

**Advantages:**
- Works without browser cookie support
- User-controlled submission

**Disadvantages:**
- Manual implementation required
- Manual form creation needed
- More complex code

#### 3. **URL Rewriting**
- Session ID appended to URL as query parameter
- Automatic by container with encodeRedirectURL()
- Used when cookies disabled
- Alternative to cookies

```java
// URL rewriting example
String url = response.encodeRedirectURL("/nextpage", sessionId);
response.sendRedirect(url);

// Result: /nextpage;jsessionid=ABC123XYZ
```

```java
// Retrieving session ID from URL
String sessionId = request.getRequestedSessionId();
```

**Advantages:**
- Works without cookies
- No user action needed
- Container-managed

**Disadvantages:**
- Visible in URL (security concern)
- Not bookmarkable
- Longer URLs

#### 4. **HttpSession (Recommended)**
- Server-side session management
- Automatic by servlet container
- Object-oriented approach
- Most secure and convenient

```java
// Create/get session
HttpSession session = request.getSession();
String sessionId = session.getId();

// Store data
session.setAttribute("username", "john");

// Retrieve data
String username = (String) session.getAttribute("username");

// Remove data
session.removeAttribute("username");

// Invalidate session
session.invalidate();
```

**Advantages:**
- Automatic by container
- Secure (server-side storage)
- Easy to use
- Object-oriented
- Can store any Java object

**Disadvantages:**
- Requires server resources
- Not suitable for distributed systems without replication

---

### Session Tracking Comparison Table

| Technique | Method | Persistence | Security | Complexity | Use Case |
|-----------|--------|-------------|----------|-----------|----------|
| **Cookies** | Client-side | Browser | Medium | Low | Default, recommended |
| **Hidden Field** | Client-side | Form submission only | Medium | Medium | Alternative to cookies |
| **URL Rewriting** | Client-side | URL parameter | Low | Low | Fallback when cookies disabled |
| **HttpSession** | Server-side | Server memory | High | Low | Enterprise, secure apps |

---

### Practical Example

```java
// First Servlet - Set session data
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate user
        if (isValidUser(username, password)) {
            // Get/create session
            HttpSession session = request.getSession();
            
            // Store user data in session
            session.setAttribute("username", username);
            session.setAttribute("loginTime", new Date());
            session.setAttribute("role", getUserRole(username));
            
            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(1800);
            
            // Redirect to dashboard
            response.sendRedirect("/dashboard");
        } else {
            request.setAttribute("error", "Invalid credentials");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}

// Second Servlet - Retrieve session data
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        // Get session (don't create new)
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            // No session, redirect to login
            response.sendRedirect("/login.jsp");
            return;
        }
        
        // Retrieve session data
        String username = (String) session.getAttribute("username");
        Date loginTime = (Date) session.getAttribute("loginTime");
        String role = (String) session.getAttribute("role");
        
        // Use session data
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>Welcome, " + username + "!</h1>");
        out.println("<p>Logged in at: " + loginTime + "</p>");
        out.println("<p>Role: " + role + "</p>");
    }
}
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

## Internal Working of Servlet

### Overview
The internal working of a servlet demonstrates how the server, servlet container, and user-defined servlets interact to process HTTP requests.

### Key Components

#### 1. **Client**
- Initiates HTTP servlet requests to the server
- Can be a web browser or any HTTP client

#### 2. **Server**
- Receives HTTP requests from the client
- Creates a `ServletConfig` object for servlet configuration
- Instantiates the servlet object (if not already created)
- Calls the init() method with ServletConfig

#### 3. **ServletConfig**
- Contains initialization parameters and servlet configuration information
- Passed to the servlet's init() method
- Provides access to init parameters defined in web.xml

#### 4. **Servlet Object**
- The actual servlet instance created by the server
- Inherits from GenericServlet or HttpServlet
- Receives the ServletConfig during initialization
- Handles service() calls for each request

### Servlet Inheritance Hierarchy

```
java.lang.Object
    ↓
GenericServlet (implements ServletConfig, Serializable)
    ↓
HttpServlet (extends GenericServlet)
    ↓
UserServlet (Your custom servlet - extends HttpServlet)
```

**GenericServlet:**
- Protocol-independent servlet
- Implements init(ServletConfig) method
- Defines abstract service() method

**HttpServlet:**
- Protocol-specific servlet for HTTP
- Extends GenericServlet
- Provides doGet(), doPost(), doPut(), doDelete() methods
- Implements service() method to route to appropriate HTTP method

**UserServlet:**
- Your custom servlet implementation
- Extends HttpServlet
- Overrides doGet(), doPost(), etc. as needed

### Internal Working Flow

```
1. Client sends HTTP request to Server
2. Server receives the request
3. Server creates ServletConfig object containing:
   - Servlet name
   - Init parameters from web.xml
   - ServletContext reference
4. Server checks if servlet instance exists
   - If not exists: Create servlet instance using no-arg constructor
   - If exists: Use existing instance
5. Server calls init(ServletConfig config) method
   - Called only once
   - Servlet initializes resources
6. Server calls service() method for each request
   - service() method routes to appropriate HTTP method:
     - GET request → doGet()
     - POST request → doPost()
     - PUT request → doPut()
     - DELETE request → doDelete()
   - User-defined logic processes the request
7. Servlet generates response
8. Response is sent back to client
9. When server shuts down:
   - Server calls destroy() method
   - Servlet cleans up resources
   - Servlet instance is removed
```

### Code Example

```java
// Custom Servlet extending HttpServlet
public class UserServlet extends HttpServlet {
    private ServletConfig config;
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.config = config;
        // Initialize resources
        System.out.println("UserServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String servletName = config.getServletName();
        out.println("<h1>Servlet: " + servletName + "</h1>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests
    }
    
    @Override
    public void destroy() {
        System.out.println("UserServlet destroyed");
        // Cleanup resources
    }
}
```

### Important Points

1. **Single Instance**: Only one instance of each servlet is created
2. **Thread Safety**: Multiple threads can execute service() simultaneously on the same servlet instance
3. **ServletConfig**: Created by the server, contains configuration for the servlet
4. **Initialization**: init() is called only once, before any service() calls
5. **Service Method**: Called for every request received by the servlet
6. **Cleanup**: destroy() is called once when servlet is removed

---

## Deployment Descriptor

### What is web.xml (Deployment Descriptor)?
- **File that contains configuration of your Java web application.**
- **It resides in the WEB-INF folder.**
- Also known as the deployment descriptor
- Defines how the web application is deployed and configured

### Structure and Location

The `web.xml` file is located in the `WEB-INF` folder of your web application:

```
YourWebApp/
├── WEB-INF/
│   ├── web.xml          ← Deployment Descriptor
│   ├── classes/
│   └── lib/
└── [your JSP and HTML files]
```

### Contents of web.xml

The `<web-app>` element contains all configuration for your web application:

```xml
<web-app>
    <!-- Servlet Declaration -->
    <servlet>
        <servlet-name>...</servlet-name>
        <servlet-class>...</servlet-class>
    </servlet>
    
    <!-- Servlet Mapping -->
    <servlet-mapping>
        <servlet-name>...</servlet-name>
        <url-pattern>...</url-pattern>
    </servlet-mapping>
    
    <!-- Initialization Parameters -->
    <init-param>
        <param-name>...</param-name>
        <param-value>...</param-value>
    </init-param>
    
    <!-- Welcome File Configuration -->
    <welcome-file-list>
        <welcome-file>...</welcome-file>
    </welcome-file-list>
    
    <!-- Filters -->
    <filter>
        <filter-name>...</filter-name>
        <filter-class>...</filter-class>
    </filter>
    
    <!-- Listeners -->
    <listener>
        <listener-class>...</listener-class>
    </listener>
    
    <!-- Session Configuration -->
    <session-config>
        ...
    </session-config>
    
    <!-- And many more configurations... -->
</web-app>
```

### Main Configuration Elements

1. **Servlet Declaration** - Defines servlets used in the application
2. **Servlet Mapping** - Maps URL patterns to servlets
3. **Initialization Parameters** - Pass configuration values to servlets
4. **Welcome Files** - Default files served for directory requests
5. **Filters** - Request/response interceptors
6. **Listeners** - Event listeners for application lifecycle
7. **Session Configuration** - Session timeout and cookie settings
8. **Error Pages** - Error handling configuration

### Example web.xml Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <display-name>My Web Application</display-name>
    
    <!-- Servlet Configuration -->
    <servlet>
        <servlet-name>HelloServlet</servlet-name>
        <servlet-class>com.example.HelloServlet</servlet-class>
        <init-param>
            <param-name>author</param-name>
            <param-value>John Doe</param-value>
        </init-param>
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

---

## Parameters and Attributes in Servlet

### Understanding Parameters

#### What are Parameters?
- **Parameters are values provided by the user to any servlet to process the request during the request operation.**
- Servlet only **reads** that value for request processing
- Parameters mostly come from **HTML forms** and **initialization parameters** (defined in web.xml)
- They are **user-provided data**

#### How to Get Parameters

```java
// Get single parameter value
String name = request.getParameter("name_of_your_parameter");

// Example from HTML form with course=java
String course = request.getParameter("course");

// Now process your request using the parameter value
```

#### Parameter Sources

1. **HTML Form Parameters** (User Input)
   ```html
   <form method="GET" action="/myservlet">
       <input type="text" name="username">
       <input type="password" name="password">
       <input type="submit">
   </form>
   ```
   
2. **Query String Parameters**
   - `http://example.com/servlet?name=John&course=Java`

3. **Initialization Parameters** (web.xml)
   ```xml
   <init-param>
       <param-name>database.url</param-name>
       <param-value>jdbc:mysql://localhost:3306/mydb</param-value>
   </init-param>
   ```

#### Example Usage

```java
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        // Get parameters from form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String course = request.getParameter("course");  // e.g., "java"
        
        // Process the request using these parameters
        if (isValidUser(username, password)) {
            // Process login
        }
    }
}
```

---

### Understanding Attributes

#### What are Attributes?
- **Attributes are objects that are attached by one servlet to an object (session, request, config, context, etc.)**
- **Other servlets can fetch that object to process to logic**
- Attributes are **mutable** - servlets can easily **modify, add, and remove** the content of attributes when required
- They are **server-side data** shared between servlets

#### Attribute Operations

You can perform these operations with attributes:

1. **setAttribute(String name, String value)** - Store an attribute
2. **Object value = getAttribute(String name)** - Retrieve an attribute
3. **removeAttribute(String name)** - Remove an attribute

#### Example Usage

```java
// Servlet 1: Set an attribute
public class FirstServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        // Create an attribute
        String userData = "Important data from FirstServlet";
        
        // Set attribute in request object
        request.setAttribute("userInfo", userData);
        
        // Forward to another servlet
        RequestDispatcher dispatcher = request.getRequestDispatcher("/secondServlet");
        dispatcher.forward(request, response);
    }
}

// Servlet 2: Retrieve and use the attribute
public class SecondServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        // Get the attribute set by FirstServlet
        String userInfo = (String) request.getAttribute("userInfo");
        
        // Use the attribute in business logic
        System.out.println("Received: " + userInfo);
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>User Info: " + userInfo + "</h1>");
    }
}
```

### Parameters vs Attributes Comparison

| Feature | Parameters | Attributes |
|---------|-----------|-----------|
| **Source** | User-provided (form, URL, init-param) | Server-side, set by servlets |
| **Type** | String values | Any Java Object |
| **Read/Write** | Read-only (by servlet) | Read, Write, Modify, Remove |
| **Scope** | Request-specific | Request, Session, ServletContext |
| **Purpose** | Input from user | Data sharing between servlets |
| **Persistence** | Single request | Multiple requests (if session/context) |
| **Example** | Form data, query string | User object, cached data |

#### Attribute Scopes

1. **Request Scope**
   ```java
   request.setAttribute("key", value);
   Object obj = request.getAttribute("key");
   ```
   - Available only for current request
   - Lost after response sent

2. **Session Scope**
   ```java
   HttpSession session = request.getSession();
   session.setAttribute("key", value);
   Object obj = session.getAttribute("key");
   ```
   - Available across multiple requests from same user
   - Lost when session expires

3. **ServletContext Scope**
   ```java
   ServletContext context = getServletContext();
   context.setAttribute("key", value);
   Object obj = context.getAttribute("key");
   ```
   - Available to all servlets in the application
   - Lost when application stops

---

## RequestDispatcher

### What is RequestDispatcher?
RequestDispatcher is responsible for dispatching the request to another resource. It may dispatch the request to an HTML file, servlet, or JSP page.

### RequestDispatcher Methods

There are two methods defined in the RequestDispatcher interface:

#### 1. **forward() method**
- Forwards a request from one servlet to another resource (servlet, JSP, or HTML).
- The request and response objects are passed to the target resource.
- The client receives the response from the target resource, not the forwarding servlet.
- **Important**: Response headers and status code cannot be modified after forward() is called.

```java
public void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    
    // Forward to another servlet or JSP
    RequestDispatcher dispatcher = request.getRequestDispatcher("/nextServlet");
    dispatcher.forward(request, response);
}
```

**forward() Flow:**
```
1) Client sends request to Servlet1
2) Servlet1 forwards request to Servlet2 using forward()
3) Servlet2 processes request and generates response
4) Response is sent back to client
5) Client only sees response from Servlet2
```

#### 2. **include() method**
- Includes the response of another resource within the current response.
- The response from the target resource is included in the response of the current servlet.
- Both resources contribute to the final response.
- Used to include headers, footers, or common content.

```java
public void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();
    
    out.println("<h1>Header</h1>");
    
    // Include response from another servlet
    RequestDispatcher dispatcher = request.getRequestDispatcher("/headerServlet");
    dispatcher.include(request, response);
    
    out.println("<h1>Footer</h1>");
}
```

**include() Flow:**
```
1) Client sends request to Servlet1
2) Servlet1 generates some content
3) Servlet1 includes response from Servlet2 using include()
4) Servlet2 response is included in Servlet1 response
5) Servlet1 generates remaining content
6) Final combined response is sent to client
```

### Getting RequestDispatcher

```java
// Method 1: Using path
RequestDispatcher dispatcher = request.getRequestDispatcher("/path/to/resource");

// Method 2: Using servlet name
RequestDispatcher dispatcher = request.getRequestDispatcher("/servletName");

// Method 3: Using ServletContext
ServletContext context = getServletContext();
RequestDispatcher dispatcher = context.getRequestDispatcher("/resource");

// Method 4: Named dispatcher
ServletContext context = getServletContext();
RequestDispatcher dispatcher = context.getNamedDispatcher("servletName");
```

### Code Example: forward()
```java
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate credentials
        if (isValidUser(username, password)) {
            request.setAttribute("user", username);
            // Forward to dashboard
            RequestDispatcher dispatcher = request.getRequestDispatcher("/dashboard");
            dispatcher.forward(request, response);
        } else {
            // Forward to login error page
            request.setAttribute("error", "Invalid credentials");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/loginError.jsp");
            dispatcher.forward(request, response);
        }
    }
}
```

### Code Example: include()
```java
@WebServlet("/page")
public class PageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Include header
        RequestDispatcher header = request.getRequestDispatcher("/header");
        header.include(request, response);
        
        // Main content
        out.println("<div class='content'>");
        out.println("<h1>Main Page Content</h1>");
        out.println("</div>");
        
        // Include footer
        RequestDispatcher footer = request.getRequestDispatcher("/footer");
        footer.include(request, response);
    }
}
```

### forward() vs include() Comparison

| Feature | forward() | include() |
|---------|-----------|-----------|
| **Purpose** | Transfer control to another resource | Include response from another resource |
| **Response Contribution** | Only target resource contributes | Both current and target resource contribute |
| **Request/Response Passing** | Same request and response objects | Same request and response objects |
| **URL in Browser** | Remains same as forwarding servlet | Remains same as current servlet |
| **Use Case** | Navigation, conditional routing | Headers, footers, common content |
| **Response Headers** | Can be set before forward | Can be set in included resource |

---

## Welcome Files and Resource Mapping

### What are Welcome Files?
Welcome files are the default resources served when a directory is requested without specifying a file name.

When a user accesses `www.example.com` or `www.example.com/`, the server automatically looks for welcome files in the configured list and serves the first match found.

### Configuring Welcome Files in web.xml
```xml
<welcome-file-list>
    <welcome-file>home.jsp</welcome-file>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
```

**Order Matters**: The files are searched in the order they are specified.

### Welcome Files Example
If the welcome-file-list is configured as shown above:
1. User visits: `www.onlyjavatecgh.com`
2. Server looks for `home.jsp` → if found, serves it
3. If not found, looks for `index.html` → if found, serves it
4. If not found, looks for `index.jsp` → if found, serves it
5. If none found, returns directory listing or 404 error

### Welcome Files Server-Side Processing

```
Client Request:
    ↓
www.onlyjavatecgh.com
    ↓
Server receives request for root directory
    ↓
Checks welcome-file-list in order
    ↓
Request is internally forwarded to home.jsp
    ↓
home.jsp processes the request
    ↓
Response is sent back to client
```

### Practical Scenario

**web.xml Configuration:**
```xml
<welcome-file-list>
    <welcome-file>home.jsp</welcome-file>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
```

**Available Resources on Server:**
- `/home.jsp` - exists
- `/index.html` - exists
- `/index.jsp` - exists

**Request Handling:**
- `http://www.onlyjavatecgh.com` → Serves `home.jsp` (first in list)
- Response contains content from `home.jsp`

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
- **Session Tracking**: Multiple techniques to maintain user state (Cookies, Hidden Fields, URL Rewriting, HttpSession)
- **Filters**: Intercept requests for cross-cutting concerns
- **Internal Working**: Understand how servlets are created, initialized, and destroyed
- **Deployment Descriptor**: web.xml configures your web application
- **Parameters and Attributes**: Use parameters for user input and attributes for server-side data sharing
- **RequestDispatcher**: Forward or include requests to other resources
- **Welcome Files**: Configure default resources for directory requests
- **Best Practices**: Security, performance, scalability, and code quality matter

For modern applications, consider using frameworks like Spring, Quarkus, or Jakarta EE which simplify servlet development.

---

## Resources

- [Jakarta Servlet Specification](https://jakarta.ee/specifications/servlet/)
- [Apache Tomcat Documentation](https://tomcat.apache.org/tomcat-9.0-doc/)
- [Oracle Java EE Tutorials](https://docs.oracle.com/javaee/)
- [Java Servlet Official API Docs](https://docs.oracle.com/javaee/7/api/javax/servlet/package-summary.html)
