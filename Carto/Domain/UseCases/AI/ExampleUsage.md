// Initialize Infrastructure Engine Client
let client = GroqClient(apiKey: AppEnvironment.groqApiKey)

// 1. Inject client dependency into the repository layer
let aiRepository: AIRepository = AIRepositoryImpl(client: client)

// 2. Initialize individual domain layer use cases
let compareProductsUseCase = CompareProductsUseCase(repository: aiRepository)
let runShoppingAssistantUseCase = RunShoppingAssistantUseCase(repository: aiRepository)
let extractKeywordsFromImageUseCase = ExtractKeywordsFromImageUseCase(repository: aiRepository)
let generateOutfitSuggestionsUseCase = GenerateOutfitSuggestionsUseCase(repository: aiRepository)
let generatePersonalizedInsightsUseCase = GeneratePersonalizedInsightsUseCase(repository: aiRepository)

let mockCatalog = [
Product(id: 1, title: "Nomad Canvas Backpack", description: "Water-resistant travel bag", vendor: "Trailhead Co", productType: "Bags", handle: "nomad-bag", status: "active", tags: ["travel", "canvas", "waterproof"], variants: [ProductVariant(id: 11, productId: 1, title: "Standard / Olive", price: "85.00", sku: "NMD-OLV", compareAtPrice: nil, inventoryQuantity: 14)], images: [ProductImage(id: 111, productId: 1, alt: "Olive bag", src: "https://image.celine.com/14aa2b37033f90d/original/2Y321670Q-38AW_1_SUM21_V.jpg?im=Resize=(1200)")], options: [ProductOption(id: 1111, productId: 1, name: "Color", values: ["Olive", "Black"])]),
Product(id: 2, title: "Apex Running Shoes", description: "Responsive carbon-plated shoe", vendor: "Stride Labs", productType: "Footwear", handle: "apex-run", status: "active", tags: ["running", "carbon", "athletic"], variants: [ProductVariant(id: 22, productId: 2, title: "US 10 / White", price: "160.00", sku: "APX-WHT", compareAtPrice: "180.00", inventoryQuantity: 5)], images: [ProductImage(id: 222, productId: 2, alt: "White shoe", src: "https://everkix.com/cdn/shop/files/23.jpg?v=1779755085")], options: [ProductOption(id: 2222, productId: 2, name: "Size", values: ["9", "10", "11"])])
]

Task {
do {
// =================================================================
// 1. AI PRODUCT COMPARISON
// =================================================================
print("📊 Requesting structured JSON comparison matrix...")
let comparisonData = try await compareProductsUseCase.execute(productsToCompare: mockCatalog)
print("✅ Comparison Verdict: \(comparisonData.verdict)")
print("Parsed Metrics: \(comparisonData.comparisons.map { $0.metricName })")

// =================================================================
// 2. AI SHOPPING ASSISTANT (Smart Chat)
// =================================================================
print("\n💬 Querying Chat Assistant...")
let chatData = try await runShoppingAssistantUseCase.execute(
userQuery: "Do you have any lightweight running gear?",
chatHistory: [],
availableCatalog: mockCatalog
)
print("✅ Assistant Reply: \(chatData.replyText)")
print("Suggested Interactive Product IDs: \(chatData.recommendedProductIds)")

// =================================================================
// 3. AI IMAGE SEARCH (Visual Keyword Scanner)
// =================================================================
if let sampleImage = UIImage(named: "boho_dress_sample"),
let jpegData = sampleImage.jpegData(compressionQuality: 0.7) {

print("\n📸 Dispatching image to Vision parsing parser...")
let visionSearchData = try await extractKeywordsFromImageUseCase.execute(uiImageJPEGData: jpegData)
print("✅ Extracted Search Keywords Array: \(visionSearchData.keywords)")
print("Detected Broad Categories: \(visionSearchData.detectedCategories)")
}

// =================================================================
// 4. AI OUTFIT GENERATOR (Personal Stylist Bundle Builder)
// =================================================================
print("\n👗 Requesting stylistic occasion outfit composition bundle...")
let outfitData = try await generateOutfitSuggestionsUseCase.execute(
for: "Summer Beach Wedding Gala",
catalogInventory: mockCatalog
)
print("✅ Outfit Title: \(outfitData.outfitTitle)")
print("Styling Advice: \(outfitData.stylingReasoning)")
print("Bundle Item Product IDs: \(outfitData.itemIdsInBundle)")

// =================================================================
// 5. AI SHOPPING INSIGHTS (Customer Retention Metrics)
// =================================================================
let userPurchaseHistory = [mockCatalog[0]]

print("\n📈 Building user profile analytics dashboard data...")
let insightsData = try await generatePersonalizedInsightsUseCase.execute(purchasedProducts: userPurchaseHistory)
print("✅ Extracted \(insightsData.insights.count) personalized insights targets successfully.")
for insight in insightsData.insights {
print("- \(insight.title): \(insight.meaning) -> Next Step: \(insight.suggestedNextSteps)")
}

} catch {
print("❌ Clean Architecture Layer error details: \(error.localizedDescription)")
}
}
