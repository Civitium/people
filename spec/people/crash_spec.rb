require 'spec_helper'

describe People do
  describe "with names" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "doesn't crash on" do
      expect { @np.parse("邹鸿志") }.to_not raise_error
      expect { @np.parse("Gordon Xi") }.to_not raise_error
    end

    # it "test" do
    #   arr = ["Hung Chih (Michael) Chang", "Ann Yoo Porsild Lynard", "Eric E. Silverman JD, PhD", "Andrew Ahn, MD PhD FAHS", "Christian Schirvel DVM MSc CAAM", "Pedro Garbes-Netto. MD, MSc.", "Pedro Garbes-Netto. MD, MSc.", "Sari Heller Ratican, CIPP/US, CIPP/E", "Zoe Philippides Lundberg, CIPP/US", "Henny Zijlstra - Jungerius", "Christopher Hazuka, J.D., Ph.D.", "Prity Khastgir Indian Patent Attorney", "Paul Grijalva Esq. LL.M", "Miriam Alfonso de Oliveira", "Prof. Diana Derval 戴安娜.代尔瓦勒.教授", "Alice GENTIL DIT MAURIN", "Ana Miriam Fukui Dias", "Michael Vestel, Ph. D.", "Claude (Claudio II) Requino", "Catherine J. \"Kitty\" Mackey, Ph.D.", "Gordon Xi", "罗明 (Barton)", "Ashutosh Kumar Mittal, Ph.D.,", "Sladjana Stojanovic, LL.M", "Victoria J Philbin. MSc, Ph.D", "Paul B. Simboli. Esq.", "Yaseen Khan, P.Eng.", "Shela To Hang Lee", "Prity K,brevetto | Biotech|Avvocato Pharma |Patent Attorney", "Cesar Henrique Pavam, Sc.M.", "maria del pilar donayre", "Germán Jesús Quintana Escobar", "Milind Sathe Founder Compulsory Licensing Group", "Ms.Nasim G. Memon, Sc.M.", "Sarah M. Poorman (Gedney)", "Paul Bruinenberg MD MBA", "Mr.Manjunath karad", "Ramesh Rameshs.Chem", "Shiva Kumar S M", "Dr.Narasimha Sarma", "Aleksandra T.", "James Beatley - Lilly's Co-Worker", "Fabiana de Vasconcelos Vieira", "Julie (Capps McGrath) John", "Yuly Marin Garcia, BSc, Mcb.A., RM(CCM).", "邹鸿志", "Patrick E. Zeller, CIPP/US", "Judy (R&D)", "ארז ליאור", "Rodrigo Vasquez D., PhD", "A. H. M. Ahsan Habib", "Georg Buchner PhD MBA", "G.KATHIR VASAGAN", "Arvind Singh Medical Affairs (M.Biomed, Ph.D. Micro)", "Savvy Librarian for Academic Libraries", "Prity | IP Patent Researcher| FTO Analysis", "Lars-P. Sandsdalen", "Lars-P. Sandsdalen", "陈忠", "Mhd. Muammar Hakki", "Daniel Young, Sc.D.", "Jordan Bradley Michael CIPP/US/EU", "Elisabeth Piquenot (English profile)", "Veronika Hornung, Dr.", "Andrew Man Ching Lee", "Musa Unmehopa MBA MSc", "Innovation Prize | Innovation Days", "Plamondon/Fournier Louis", "Анна Мухина", "Dr. Joachim Spalcke M.C.L.", "Charles A. (Charlie) McCleary", "Robert Snyder, JD., MPH.", "J. Michael Martinez de Andino", "Alex Carberry - MCP", "Peter Van De Witte", "Ma. Patricia Buckley", "Angell Xi", "John A. \"Jay\" Rafter, Jr.", "Man Ling Angela Wong", "Jan Willem de Vries", "Susan A. (Sam) Manardo", "pallavi Pallavi.Gujjari", "Mohana Murali Krishn Adru", "Prof. dr. Ben van Lier CMC", "Josiah N. \"Cy\" Wilcox", "Federico A. (Rick) Amorini", "Tuire Kolev, LL.M. IP and Competition Law", "Yvette Gregory, MS", "Inder Nirbhay Singh Tiwana", "Ashley Pittman, J.D., LL.M", "Megan C.", "Carlos Alberto Ordoñez C.", "Akriti .", "Professor Gruener", "Savvy Librarian for Academic Libraries"]
    #   arr.each{|a| puts a; p @np.parse(a)}
    # end
  end
end
