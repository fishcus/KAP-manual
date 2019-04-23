## Integrate with 3rd-party User Authentication System

In addition to the user authentication integration with LDAP, Kyligence Enterprise also supports the integration with 3rd-party user authentication systems during a system login.

By default, Kyligence Enterprise has its user management system that provides user authentication and authorization. When a user logs into Kyligence Enterprise, the system verifies the current user's username and password to confirm the identity. If verified, the user logs in successfully. Kyligence Enterprise also provides an extended interface for user authentication. In this case, the system will connect to a 3rd-party user authentication system to verify a user during the log in.

This section describes the principles and implementation steps to integrate with the 3rd-party user authentication system.

### How It Works

The image below descripes the mechanism of integrating with a 3rd-party user authentication system:

![User Authentication Integration with 3rd-party System](images/3rd_um/3rdPartyAuthentication.png)

Therefore, the key to integration with the 3rd-party user authentication system is to implement a customized extension, which connects to the 3rd-party user authentication system for user verification.

### How to Use

#### Step 1. Build Development Environment

Unzip `$KYLIN_HOME/samples/static-user-manager.tar.gz`. This is the sample project with `pom.xml` and maven project defined. Import it into your Java IDE.

Add Kyligence Enterprise library `$KYLIN_HOME/tool/kylin-tool-kap-[version].jar` to your project lib, and add the lib directory to your classpath.

The sample creates a memory-based user system with two users, *admin* and *test*, *admin* with administrator privileges and *test* with browse permissions.

#### Step 2. Implement Java Class for Docking 3rd-party User System

To implement 3rd-party user authentication extensions, you need to implement these three classes in Kyligence Enterprise: *KapOpenUserService (optional)*, *KapOpenUserGroupService (optional)*, *KapOpenAuthenticationProvider (necessary)*.

- KapOpenUserService: return the user list, check if the user exists, and return the administrator list, etc. If you are using the built-in user management in system, you do not need to implement these methods.
- KapOpenUserGroupService: return a list of user groups, return user group members, etc. If you are using the built-in user management in system, you do not need to implement these methods.
- KapOpenAuthenticationProvider: verify whether the login user is legal. This class must be implemented.

Below introduces how to implement these three classes through the sample template.

1. Implementation template for the *KapOpenUserService* class：

   ```java
   public class StaticUserService extends KapOpenUserService {
   		private static final Logger logger = LoggerFactory.getLogger(StaticUserService.class);
   		private List<ManagedUser> users = Lists.newArrayList();
     
      	@PostConstruct
      	public void init() throws IOException {
           ManagedUser admin = new ManagedUser();
           admin.addAuthorities(Constant.ROLE_ADMIN);
           admin.setPassword("123456");
           admin.setUsername("admin");
           admin.setDisabled(false);
           admin.setLocked(false);
           users.add(admin);
           ManagedUser test = new ManagedUser();
           test.addAuthorities(Constant.ROLE_ANALYST);
           test.setPassword("123456");
           test.setUsername("test");
           test.setDisabled(false);
           test.setLocked(false);
           users.add(test);
      	}
   
   	@Override
      	public List<ManagedUser> listUsers() {
      			return users;
      	}
      
      	@Override
      	public List<String> listAdminUsers() {
           List<String> admins = Lists.newArrayList();
           for (ManagedUser user : users) {
             if (user.getAuthorities().contains(new SimpleGrantedAuthority(Constant.ROLE_ADMIN))) {
               admins.add(user.getUsername());
             }
           }
           return admins;
      	}
      
      	@Override
      	public boolean userExists(String s) {
           for (ManagedUser user : users) {
             if (s.equals(user.getUsername())) {
               return true;
             }
           }
           return false;
      	}		
   
   		@Override
      	public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {
           for (ManagedUser user : users) {
             if (s.equals(user.getUsername())) {
               return user;
             }
           }
           throw new UsernameNotFoundException(s);
      	}
   
      	@Override
      	public void completeUserInfo(ManagedUser user) {
      
      	}
   }
   ```

   - The *init()* method is used to do some initialization operations. This method must be annotated with *@PostConstruct*. In this template, we created two users.

   - *The listUsers()* method is used to return all users, and the return value of this method is a collection of *ManagedUser*. *ManagedUser* contains several key attributes:
     - username: username
     - password: user's password
     - disabled: whether to disable
     - locked: whether to lock
     - authorities: user's role

   ​       In this template, we return directly to the list of users after initialization: *users*

   - The *listAdminUses()* method is used to return all administrator users. The return value of this method is a **List** consisting of user names. In this template, this method simply filters out the admin users among all *users*.

   - The *userExists(String s)* method is used to return whether the user exists based on the username. In this template, we traverse the *users* directly.

   - The *loadUserByUsername(String s)* method is used to return a user.

   - The *completeUserInfo(ManagedUser user)* method is used to add user information.

     > **Note:** In Kyligence Enterprise, *completeUserInfo* is a mandotory method. Please leave it empty rather than delete it if you don't need to add user information.

   - Other methods should be implemented according to your actual needs.

2. Implementation template for the *KapOpenUserGroupService* class:

   ```java
   public class StaticUserGroupService extends KapOpenUserGroupService {
      	private static final Logger logger = LoggerFactory.getLogger(StaticUserGroupService.class);
      	
      	@Autowired
      	@Qualifier("userService")
      	UserService userService;
      	
      	@Override
      	public List<ManagedUser> getGroupMembersByName(String s) {
           try {
               List<ManagedUser> ret = Lists.newArrayList();
               List<ManagedUser> managedUsers = userService.listUsers();
               for (ManagedUser user : managedUsers) {
                 if (user.getAuthorities().contains(new SimpleGrantedAuthority(s))) {
                   ret.add(user);
                 }
               }
             	return ret;
           } catch (Exception e) {
             	throw new RuntimeException("");
           }
      	}
      	
      	@Override
      	protected List<String> getAllUserGroups() {
           List<String> groups = Lists.newArrayList();
           groups.add(Constant.ROLE_ADMIN);
           groups.add(Constant.ROLE_ANALYST);
           return groups;
       }
   }
   ```

   - The *getGroupMembersByName(String s)* returns all users in the user group. In this case, it is returned directly from the user in the UserService above.

   - The *getAllUserGroups()* returns all user groups. In this case, a static set of user group is returned directly.

   - Other methods should be covered selectively according to your actual needs.

     > **Caution:** If your user management system does not have user groups, then you only need to maintain an empty implementation in the above methods.

3. Implementation template for the *KapOpenAuthenticationProvider* class:

   ```java
   public class StaticAuthenticationProvider extends KapOpenAuthenticationProvider {
       private static final Logger logger = LoggerFactory.getLogger(StaticAuthenticationProvider.class);
     
       @Override
       public boolean authenticateImpl(Authentication authentication) {
           String name = authentication.getName();
           Object credentials = authentication.getCredentials();
           ManagedUser user = (ManagedUser) getUserService().loadUserByUsername(name);
           if (!credentials.equals(user.getPassword())) {
               return false;
           }
           return true;
       }
   }
   ```

   - The *authenticateImpl(Authentication authentication)* is used to check whether the username and password are valid, that is, whether the user is allowed to log in. The argument to this method is an *Authentication* object with two key properties:
     - *principal*: Username passed on the page
     - *credentials*: The password passed on the page
   - Other methods should be covered selectively according to your actual needs.

   

#### Step 3. Packaging, Deploying and Testing Your Java Class

1. Pack you code into a JAR file using maven

   ```shell
   mvn package -DskipTests
   ```

2. Deploy JAR file

   Put the JAR file to folder `$KYLIN_HOME/ext`.

3. Configure and restart the system

   Add the following configuration in `kylin.properties`.

   ```shell
   kylin.security.profile=custom //configure profile to custom mode
   kylin.security.custom.user-service-clz=StaticUserService //Configure the full class name of the KapOpenUserService custom implementation class (optional)
   kylin.security.custom.user-group-service-clz=StaticUserGroupService //Configure the full class name of the KapOpenUserGroupService custom implementation class,optional
   kylin.security.custom.authenticaton-provider-clz=StaticAuthenticationProvider //Configure the full class name of the KapOpenAUthenticationProvider custom implementation class (necessary)
   ```

4. Log in to Kyligence Enterprise and verify

   Now the configuration is activated and the user authentication is enabled. The user information entered when logging in will be verified by the 3rd-party system.
