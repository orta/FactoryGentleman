#import "Friendship.h"

SpecBegin(Friendship)
    __block Friendship *subject;
    __block User *fromUser, *toUser;

    before(^{
        fromUser = FGBuild(User.class);
        toUser = FGBuild(User.class);
        NSDictionary *values = @{ @"fromUser" : fromUser, @"toUser" : toUser };
        subject = FGBuildWith(Friendship.class, values);
    });

    describe(@"-users", ^{
        it(@"returns array containing from user", ^{
            expect([subject users]).to.contain(fromUser);
        });

        it(@"returns array containing to user", ^{
            expect([subject users]).to.contain(toUser);
        });
    });
SpecEnd
