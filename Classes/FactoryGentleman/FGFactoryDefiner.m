#import "FGFactoryDefiner.h"

#import "FGFactoryDefinitionRegistry.h"

@interface FGFactoryDefiner ()
@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, readonly) FGFactoryDefinitionRegistry *factoryDefinitionRegistry;
@end

@implementation FGFactoryDefiner

+ (void)initialize
{
    Class selfClass = (Class) self;
    if (selfClass != [FGFactoryDefiner class]) {
        [[self new] registerDefinitions];
    }
}

- (instancetype)initWithObjectClass:(Class)objectClass
{
    return [self initWithObjectClass:objectClass
           factoryDefinitionRegistry:[FGFactoryDefinitionRegistry sharedInstance]];
}

- (instancetype)initWithObjectClass:(Class)objectClass
          factoryDefinitionRegistry:(FGFactoryDefinitionRegistry *)factoryDefinitionRegistry
{
    self = [super init];
    if (self) {
        NSParameterAssert(objectClass);
        NSParameterAssert(factoryDefinitionRegistry);
        _objectClass = objectClass;
        _factoryDefinitionRegistry = factoryDefinitionRegistry;
    }
    return self;
}

- (void)registerDefinitions
{
    NSAssert(NO, @"Override in subclass");
}

- (void)registerBaseDefinition:(FGFactoryDefinition *)baseDefinition
                 traitDefiners:(NSDictionary *)traitDefiners
{
    [self.factoryDefinitionRegistry registerFactoryDefinition:baseDefinition
                                                     forClass:self.objectClass];
    for (NSString *trait in traitDefiners) {
        void (^traitDefiner)(FGDefinitionBuilder *) = [traitDefiners objectForKey:trait];
        FGDefinitionBuilder *builder = [FGDefinitionBuilder builder];
        traitDefiner(builder);
        FGFactoryDefinition *traitDefinition = [builder build];
        [self.factoryDefinitionRegistry registerFactoryDefinition:traitDefinition
                                                         forClass:self.objectClass
                                                            trait:trait];
    }
}

@end
