import 'models.dart';

class InMemoryStore {
  InMemoryStore._internal();
  static final InMemoryStore _instance = InMemoryStore._internal();
  factory InMemoryStore() => _instance;

  final List<Book> books = [];
  final List<UserProfile> users = [];
  final List<Review> reviews = [];

  // Seed with example data resembling the UI
  void seed() {
    // Clear existing data to ensure fresh start
    books.clear();
    users.clear();
    reviews.clear();
    users.add(UserProfile(
      id: 'u1',
      handle: '@il_sim0',
    ));

    books.addAll([
      // FICTION BOOKS
      Book(
        id: 'b1',
        title: 'EDGE OF HONOR',
        author: 'Brad Thor',
        coverUrl: 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=500&q=60',
        category: 'Fiction',
        type: 'Thriller',
        publisher: 'Atria Books',
        isbn: '9781668089330',
        year: 2025,
        pages: 448,
        language: 'EN',
        description: 'When the Buckeye City Police Department receives a disturbing letter from a person threatening to "kill thirteen innocents and one guilty" in "an act of atonement for the needless death of an innocent man," Detective Izzy Jaynes has no idea what to think. Are fourteen citizens about to be slaughtered in an unhinged act of retribution? As the investigation unfolds, Izzy realizes that the letter writer is deadly serious and she turns to her friend Holly for help.',
      ),
      Book(
        id: 'b2',
        title: 'PROJECT HAIL MARY',
        author: 'Andy Weir',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780593135204-L.jpg',
        category: 'Fiction',
        type: 'Science Fiction',
        publisher: 'Ballantine Books',
        isbn: '9780593135204',
        year: 2021,
        pages: 496,
        language: 'EN',
        description: 'Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish.',
      ),
      Book(
        id: 'b3',
        title: 'EVELYN HUGO',
        author: 'Taylor Jenkins Reid',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9781501161933-L.jpg',
        category: 'Fiction',
        type: 'Drama',
        publisher: 'Atria Books',
        isbn: '9781501161933',
        year: 2017,
        pages: 400,
        language: 'EN',
        description: 'Reclusive Hollywood movie icon Evelyn Hugo is finally ready to tell the truth about her glamorous and scandalous life.',
      ),
      Book(
        id: 'b4',
        title: 'THE GREAT GATSBY',
        author: 'F. Scott Fitzgerald',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780743273565-L.jpg',
        category: 'Fiction',
        type: 'Classic',
        publisher: 'Scribner',
        isbn: '9780743273565',
        year: 1925,
        pages: 180,
        language: 'EN',
        description: 'A classic American novel set in the Jazz Age, following the mysterious Jay Gatsby and his obsession with the beautiful Daisy Buchanan.',
      ),
      Book(
        id: 'b5',
        title: '1984',
        author: 'George Orwell',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780451524935-L.jpg',
        category: 'Fiction',
        type: 'Dystopian',
        publisher: 'Signet Classic',
        isbn: '9780451524935',
        year: 1949,
        pages: 328,
        language: 'EN',
        description: 'A dystopian social science fiction novel about totalitarian control and surveillance in a society where independent thinking is a crime.',
      ),
      Book(
        id: 'b6',
        title: 'TO KILL A MOCKINGBIRD',
        author: 'Harper Lee',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780061120084-L.jpg',
        category: 'Fiction',
        type: 'Classic',
        publisher: 'Harper Perennial',
        isbn: '9780061120084',
        year: 1960,
        pages: 376,
        language: 'EN',
        description: 'The story of young Scout Finch, whose father defends a black man falsely accused of rape in 1930s Alabama.',
      ),
      Book(
        id: 'b7',
        title: 'THE HOBBIT',
        author: 'J.R.R. Tolkien',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780547928227-L.jpg',
        category: 'Fiction',
        type: 'Fantasy',
        publisher: 'Houghton Mifflin Harcourt',
        isbn: '9780547928227',
        year: 1937,
        pages: 310,
        language: 'EN',
        description: 'The story of Bilbo Baggins, a hobbit who goes on an unexpected adventure with a group of dwarves to reclaim their homeland.',
      ),
      Book(
        id: 'b8',
        title: 'DUNE',
        author: 'Frank Herbert',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780441172719-L.jpg',
        category: 'Fiction',
        type: 'Science Fiction',
        publisher: 'Ace Books',
        isbn: '9780441172719',
        year: 1965,
        pages: 688,
        language: 'EN',
        description: 'Set on the desert planet Arrakis, Dune is the story of Paul Atreides, whose family accepts control of the planet.',
      ),
      Book(
        id: 'b9',
        title: 'HARRY POTTER',
        author: 'J.K. Rowling',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780747532699-L.jpg',
        category: 'Fiction',
        type: 'Fantasy',
        publisher: 'Bloomsbury',
        isbn: '9780747532699',
        year: 1997,
        pages: 223,
        language: 'EN',
        description: 'The story of a young wizard who discovers his magical heritage and attends Hogwarts School of Witchcraft and Wizardry.',
      ),
      Book(
        id: 'b10',
        title: 'THE MARTIAN',
        author: 'Andy Weir',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780553418026-L.jpg',
        category: 'Fiction',
        type: 'Science Fiction',
        publisher: 'Crown',
        isbn: '9780553418026',
        year: 2014,
        pages: 369,
        language: 'EN',
        description: 'An astronaut becomes stranded on Mars and must find a way to survive until rescue arrives.',
      ),
      
      // NONFICTION BOOKS
      Book(
        id: 'b11',
        title: 'SAPIENS',
        author: 'Yuval Noah Harari',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780062316097-L.jpg',
        category: 'Nonfiction',
        type: 'History',
        publisher: 'Harper',
        isbn: '9780062316097',
        year: 2014,
        pages: 443,
        language: 'EN',
        description: 'A brief history of humankind, exploring how Homo sapiens came to dominate the world.',
      ),
      Book(
        id: 'b12',
        title: 'THINKING FAST AND SLOW',
        author: 'Daniel Kahneman',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780374533557-L.jpg',
        category: 'Nonfiction',
        type: 'Psychology',
        publisher: 'Farrar, Straus and Giroux',
        isbn: '9780374533557',
        year: 2011,
        pages: 499,
        language: 'EN',
        description: 'A groundbreaking tour of the mind and explains the two systems that drive the way we think.',
      ),
      Book(
        id: 'b13',
        title: 'BECOMING',
        author: 'Michelle Obama',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9781524763138-L.jpg',
        category: 'Nonfiction',
        type: 'Biography',
        publisher: 'Crown',
        isbn: '9781524763138',
        year: 2018,
        pages: 426,
        language: 'EN',
        description: 'An intimate memoir by the former First Lady of the United States.',
      ),
      Book(
        id: 'b14',
        title: 'ATOMIC HABITS',
        author: 'James Clear',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg',
        category: 'Nonfiction',
        type: 'Self-Help',
        publisher: 'Avery',
        isbn: '9780735211292',
        year: 2018,
        pages: 320,
        language: 'EN',
        description: 'An easy and proven way to build good habits and break bad ones.',
      ),
      Book(
        id: 'b15',
        title: 'THE IMMORTAL LIFE OF HENRIETTA LACKS',
        author: 'Rebecca Skloot',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9781400052189-L.jpg',
        category: 'Nonfiction',
        type: 'Science',
        publisher: 'Crown',
        isbn: '9781400052189',
        year: 2010,
        pages: 381,
        language: 'EN',
        description: 'The story of how one woman\'s cells became one of the most important tools in medicine.',
      ),
      
      // YOUNG ADULT BOOKS
      Book(
        id: 'b16',
        title: 'THE HUNGER GAMES',
        author: 'Suzanne Collins',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780439023481-L.jpg',
        category: 'Young Adult',
        type: 'Dystopian',
        publisher: 'Scholastic',
        isbn: '9780439023481',
        year: 2008,
        pages: 374,
        language: 'EN',
        description: 'In a dystopian future, teenagers fight to the death in televised games.',
      ),
      Book(
        id: 'b17',
        title: 'THE FAULT IN OUR STARS',
        author: 'John Green',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780525478812-L.jpg',
        category: 'Young Adult',
        type: 'Romance',
        publisher: 'Dutton Books',
        isbn: '9780525478812',
        year: 2012,
        pages: 313,
        language: 'EN',
        description: 'A story about two teenagers who meet in a cancer support group and fall in love.',
      ),
      Book(
        id: 'b18',
        title: 'DIVERGENT',
        author: 'Veronica Roth',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780062024022-L.jpg',
        category: 'Young Adult',
        type: 'Dystopian',
        publisher: 'Katherine Tegen Books',
        isbn: '9780062024022',
        year: 2011,
        pages: 487,
        language: 'EN',
        description: 'In a dystopian Chicago, society is divided into five factions based on personality.',
      ),
      
      // GRAPHICS BOOKS
      Book(
        id: 'b19',
        title: 'WATCHMEN',
        author: 'Alan Moore',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780930289232-L.jpg',
        category: 'Graphics',
        type: 'Superhero',
        publisher: 'DC Comics',
        isbn: '9780930289232',
        year: 1987,
        pages: 416,
        language: 'EN',
        description: 'A groundbreaking graphic novel that deconstructs the superhero genre.',
      ),
      Book(
        id: 'b20',
        title: 'MAUS',
        author: 'Art Spiegelman',
        coverUrl: 'https://covers.openlibrary.org/b/isbn/9780394747231-L.jpg',
        category: 'Graphics',
        type: 'Biography',
        publisher: 'Pantheon',
        isbn: '9780394747231',
        year: 1986,
        pages: 296,
        language: 'EN',
        description: 'A graphic novel depicting the author\'s father\'s experiences during the Holocaust.',
      ),
    ]);

    reviews.add(Review(
      id: 'r1',
      bookId: 'b1',
      userId: 'u1',
      title: 'Amazing book 👍🏻',
      body: 'Loved the pacing and characters.',
      rating: 4.0,
      likes: 3,
    ));
  }

  // CRUD for reviews
  List<Review> getReviews() => List.unmodifiable(reviews);

  void addReview(Review review) {
    reviews.insert(0, review);
  }

  void updateReview(Review updated) {
    final index = reviews.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      reviews[index] = updated;
    }
  }

  void deleteReview(String id) {
    reviews.removeWhere((r) => r.id == id);
  }
}


