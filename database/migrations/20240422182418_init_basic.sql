
-- +goose Up
CREATE TABLE organizations (
    organizationID int AUTO_INCREMENT PRIMARY KEY,
    name varchar(100) DEFAULT '',
    location varchar(100) DEFAULT '',
    license varchar(100) DEFAULT '',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE users (
    userID int AUTO_INCREMENT PRIMARY KEY,
    organizationID int,
    firstName varchar(100) DEFAULT '',
    lastName varchar(100) DEFAULT '',
    email varchar(100) DEFAULT '' UNIQUE,
    phoneNumber varchar(100) DEFAULT '',
    city varchar(100) DEFAULT '',
    userType ENUM('user', 'admin', 'superadmin') DEFAULT 'user',
    password varchar(100) DEFAULT '',
    passwordCode varchar(100) DEFAULT '',
    profilePicture varchar(100) DEFAULT '',
    language varchar(100) DEFAULT 'fi',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (organizationID) REFERENCES organizations(organizationID) ON DELETE SET NULL
);

CREATE TABLE events (
    eventID int AUTO_INCREMENT PRIMARY KEY,
    organizationID int,
    name varchar(100) DEFAULT '',
    location varchar(100) DEFAULT '',
    type varchar(100) DEFAULT '',
    date varchar(100) DEFAULT '',
    image varchar(100) DEFAULT '',
    isPublic ENUM('true', 'false') DEFAULT 'true',
    status ENUM('active', 'inactive', 'scheduled', 'redirect') DEFAULT 'active',
    ticketSaleUrl varchar(1000) DEFAULT '',
    activeFrom DATE DEFAULT null,
    activeTo DATE DEFAULT null,
    trendingScore int DEFAULT 0,
    ticketMaxPrice int DEFAULT null,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (organizationID) REFERENCES organizations(organizationID) ON DELETE SET NULL
);

CREATE TABLE tickets (
    ticketID int AUTO_INCREMENT PRIMARY KEY,
    userID int,
    eventID int,
    header varchar(100) DEFAULT '',
    description varchar(200) DEFAULT '',
    price int DEFAULT 0,
    quantity int DEFAULT 0,
    requiresMembership ENUM('true', 'false') DEFAULT 'false',
    association varchar(100) DEFAULT '',
    isSelling ENUM('true', 'false') DEFAULT 'true',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (eventID) REFERENCES events(eventID) ON DELETE CASCADE
);

CREATE TABLE advertisements (
    advertisementID int AUTO_INCREMENT PRIMARY KEY,
    advertiser varchar(100) DEFAULT '',
    contentHtml varchar(1000) DEFAULT '',
    isActive ENUM('true', 'false') DEFAULT 'true',
    views int DEFAULT 0,
    clicks int DEFAULT 0,
    redirectUrl varchar(1000) DEFAULT '',
    type ENUM('local', 'global', 'toast') DEFAULT 'global',
    location varchar(100) DEFAULT '',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE chats (
    chatID int AUTO_INCREMENT PRIMARY KEY,
    user1ID int,
    user2ID int,
    ticketID int,
    isActive ENUM('true', 'false') DEFAULT 'true',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user1ID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (user2ID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (ticketID) REFERENCES tickets(ticketID) ON DELETE CASCADE
);

CREATE TABLE messages (
    messageID int AUTO_INCREMENT PRIMARY KEY,
    chatID int,
    senderID int,
    receiverID int,
    content varchar(1000) DEFAULT '',
    isRead ENUM('true', 'false') DEFAULT 'false',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (chatID) REFERENCES chats(chatID) ON DELETE CASCADE,
    FOREIGN KEY (senderID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (receiverID) REFERENCES users(userID) ON DELETE CASCADE
);

CREATE TABLE subscription (
    subscriptionID int AUTO_INCREMENT PRIMARY KEY,
    userID int,
    endpoint varchar(1000) DEFAULT '' UNIQUE,
    publicKey varchar(1000) DEFAULT '',
    authToken varchar(1000) DEFAULT '',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE
);

-- +goose Down
DROP TABLE subscriptions;
DROP TABLE messages;
DROP TABLE chats;
DROP TABLE advertisements;
DROP TABLE tickets;
DROP TABLE events;
DROP TABLE users;
DROP TABLE organizations;
