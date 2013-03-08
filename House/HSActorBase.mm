//
//  b2ActorComplex.m
//  House
//
//  Created by traintrackcn on 13-3-5.
//
//

#import "HSActorBase.h"
#import "HSWorldManager.h"
#import "Box2D.h"

#import "b2BodyList.h"
#import "b2JointList.h"
#import "b2Vec2List.h"

#import "HSActorDescriptionManager.h"
#import "HSDynamicTreeManager.h"
#import "HSActorManager.h"


@interface HSActorBase(){
    
    b2BodyList *m_bodies;
    b2JointList *m_joints;
    
    
    b2World *world;
    
    int b2BodyBaseIdx;
    
    b2Vec2 b2PosOffset;
    
//    b2Vec2List *verticesGround;
}

@end

@implementation HSActorBase


- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (id)initWithKey:(NSString *)key glPosOffset:(CGPoint)glPosOffset filter:(b2Filter)filter{
    self = [self init];
    if (self) {
        _filter = filter;
        b2PosOffset = [[HSWorldManager sharedInstance] convertToB2PosForGLPos:glPosOffset];
        //init proxyId & actorId
        [self resetProxyId];
        b2BodyBaseIdx = 0;
        
        
        world = [HSWorldManager sharedb2World];
        id worldValue = [[HSActorDescriptionManager sharedInstance] getValueForKey:key];
//        LOG_DEBUG(@"worldValue -> %@", worldValue);
        [self parse:worldValue];
        
        [[HSActorManager sharedInstance] setValue:self];
        b2PosOffset = b2Vec2 (0,0);
    }
    
    
    return self;
}

+ (HSActorBase *)instanceWithKey:(NSString *)key glPosOffset:(CGPoint)glPosOffset filter:(b2Filter)filter{
    return [[HSActorBase alloc] initWithKey:key glPosOffset:glPosOffset filter:filter];
}



#pragma mark - properties

- (b2AABB)aabb{
    b2AABB aabb;
    aabb.lowerBound = b2Vec2(0,0);
    aabb.upperBound = b2Vec2(1.0f,1.0f);
    return aabb;
}

- (CGPoint)glPos{
    return [[HSWorldManager sharedInstance] convertToGLPosInWorldForB2Pos:[self b2Pos]];
}

- (b2Vec2)b2Pos{
    b2Body *body = [self b2Bodyy];
    if (body==NULL) {
//        LOG_DEBUG(@"body is NULL");
        return b2Vec2(0,0);
    }
    return body->GetPosition();
}


- (void)setFilterCategory:(int)category mask:(int)mask{
    _filter.categoryBits = category;
    _filter.maskBits = mask;
}

//base body used  to postion & to query aabb & to drag
- (b2Body *)b2Bodyy{
    return [m_bodies getValueAt:b2BodyBaseIdx];
}

#pragma mark - actions

- (void)actionForward{
    
}

- (void)actionBackward{
    
}

- (void)actionStop{
    
}


#pragma mark -  functions of reset

- (void)free{
    [[HSDynamicTreeManager sharedInstance] destoryProxy:_proxyId];
    [self destoryAllInB2World];
    
}

- (void)destoryAllInB2World{
    
    //    body->DestroyFixture(fixture);
    //    [self world]->DestroyBody(body);
    
//    for (int i=0; i<[m_joints count]; i++) {
//        b2Joint *joint = [m_joints getValueAt:i];
//        world -> DestroyJoint(joint);
//    }
    
//    b2Joint
    
//    b2Joint* joint = world->GetJointList();
//    int num = 0;
//    while (joint) {
//        //        LOG_DEBUG(@"j", <#__args...#>)
//        joint = joint->GetNext();
//        num ++;
//    }
//    LOG_DEBUG(@"joint count left -> %d", num);
//    world->GetJointCount()
    
    
    

    // remove body also removed joint attached body
    for (int i=0; i<[m_bodies count]; i++) {
        b2Body *body = [m_bodies getValueAt:i];
        world -> DestroyBody(body);
    }
    
//    LOG_DEBUG(@"jointCount -> %d", world->GetJointCount());
    
    [m_bodies free];
    [m_joints free];
    [_verticesG free];
}



- (void)resetProxyId{
    _proxyId = -1;
    _actorId = _proxyId;
}


#pragma mark - parsing data

- (void)parse:(id)worldValue{
    
    
    if (worldValue == nil) {
        LOG_ERROR(@"Cannot create actor, value is nil");
    }
    
    NSArray *bodyValueArr = [worldValue objectForKey:@"body"];
    int bodyCount = [bodyValueArr count];
    
    m_bodies = [[b2BodyList alloc] initWithSize:bodyCount];
    
    for (int i=0; i<bodyCount; i++) {
        id bodyValue = [bodyValueArr objectAtIndex:i];
//        b2Body* body = [self j2b2Body:bodyValue];
//        LOG_DEBUG(@"bodyValue -> %@", bodyValue);
        [self j2b2Body:bodyValue bodyIndex:i];
        //                m_bodies.push_back(body);
        //                m_indexToBodyMap[i] = body;
    }
    
//    return;
    
    //need two passes for joints because gear joints reference other joints
    NSArray *jointValueArr = [worldValue objectForKey:@"joint"];
    int jointCount = [jointValueArr count];
    
    m_joints = [[b2JointList alloc] initWithSize:jointCount];
    
    for (int i=0; i<jointCount; i++) {
        id jointValue = [jointValueArr objectAtIndex:i];
        NSString *type = [self jsonToString:@"type" jsonObj:jointValue];
        if ( ![type isEqualToString:@"gear"] ) {
            [self j2b2Joint:jointValue];
        }
    }
    
    for (int i=0; i<[jointValueArr count]; i++) {
        id jointValue = [jointValueArr objectAtIndex:i];
        NSString *type = [self jsonToString:@"type" jsonObj:jointValue];
        if ([type isEqualToString:@"gear"] ) {
            [self j2b2Joint:jointValue];
        }
    }
    
}

- (void)j2b2Body:(id)bodyValue bodyIndex:(int)bodyIndex{
    
//    LOG_DEBUG(@"bodyValue allKeys -> %@", [bodyValue allKeys]);
    
    NSString *bodyName = [self jsonToString:@"name" jsonObj:bodyValue];
    LOG_DEBUG(@"bodyName -> %@", bodyName);
    if ([bodyName isEqualToString:@"_ground"]) {
        [m_bodies addValue:NULL];
        return;
    }// testGround won't display
    
    b2Body* body = NULL;
    
    b2BodyDef bodyDef;
    
    
    
    bodyDef.type = (b2BodyType)[self jsonToInt:@"type" jsonObj:bodyValue defaultValue:0];
    
    bodyDef.position = [self jsonToVecOffset:@"position" jsonObj:bodyValue];
    
    
    bodyDef.angle = [self jsonToFloat:@"angle" jsonObj:bodyValue defaultValue:0];
    
    bodyDef.linearVelocity =[self jsonToVec:@"linearVelocity" jsonObj:bodyValue];
    
    bodyDef.angularVelocity = [self jsonToFloat:@"angularVelocity" jsonObj:bodyValue defaultValue:0];
    bodyDef.linearDamping = [self jsonToFloat:@"linearDamping" jsonObj:bodyValue defaultValue:0];
    
    bodyDef.angularDamping = [self jsonToFloat:@"angularDamping" jsonObj:bodyValue defaultValue:0];
    
    bodyDef.gravityScale =  [self jsonToFloat:@"gravityScale" jsonObj:bodyValue defaultValue:1.0f];
    
    bodyDef.allowSleep = [self jsonToBool:@"allowSleep" jsonObj:bodyValue defaultValue:YES];
    
    bodyDef.awake = [self jsonToBool:@"awake" jsonObj:bodyValue defaultValue:YES];
    
    bodyDef.fixedRotation = [self jsonToBool:@"fixedRotation" jsonObj:bodyValue defaultValue:NO];
    bodyDef.bullet = [self jsonToBool:@"bullet" jsonObj:bodyValue defaultValue:NO];
    bodyDef.active = [self jsonToBool:@"active" jsonObj:bodyValue defaultValue:YES];

    body = world->CreateBody(&bodyDef);
    
    if ( [bodyName isEqualToString:@""] ) {
        [m_bodies addValue:body];        
    }else{
        [m_bodies addValue:body withName:bodyName];
    }
    
//    return;
    
    
    
    NSArray *fixtureValueArr = [bodyValue objectForKey:@"fixture"];
    for (int i=0; i< [fixtureValueArr count]; i++) {
        id fixtureValue = [fixtureValueArr objectAtIndex:i];
//        LOG_DEBUG(@"i->%d", i);
        [self j2b2Fixture:fixtureValue body:body bodyIndex:bodyIndex];
    }
        

    
    //may be necessary if user has overridden mass characteristics
    b2MassData massData;
    massData.mass = [self jsonToFloat:@"massData-mass" jsonObj:bodyValue defaultValue:0];
//    massData.center = [self jsonToVec:@"massData-center" jsonObj:bodyValue]; //mass-center need local location
    massData.center = [self jsonToVec:@"massData-center" jsonObj:bodyValue]; //mass-center need local location
    massData.I = [self jsonToFloat:@"massData-I" jsonObj:bodyValue defaultValue:0];
    body->SetMassData(&massData);
    
//    LOG_DEBUG(@"massData.center %f %f", massData.center.x,massData.center.y);
    
//    LOG_DEBUG(@"create body end ===================");
}


- (void)j2b2Fixture:(id)fixtureValue body:(b2Body*)body bodyIndex:(int)bodyIndex{
    
    NSString *fixtureName = [self jsonToString:@"name" jsonObj:fixtureValue];
    LOG_DEBUG(@"fixtureName -> %@ bodyIndex -> %d", fixtureName, bodyIndex);
    
    b2Fixture* fixture = NULL;
    
    b2FixtureDef fixtureDef;
    fixtureDef.restitution = [self jsonToFloat:@"restitution" jsonObj:fixtureValue defaultValue:0];
    fixtureDef.friction = [self jsonToFloat:@"friction" jsonObj:fixtureValue defaultValue:0];
    fixtureDef.density = [self jsonToFloat:@"density" jsonObj:fixtureValue defaultValue:0];
    fixtureDef.isSensor = [self jsonToBool:@"sensor" jsonObj:fixtureValue defaultValue:NO];
    
    fixtureDef.filter.categoryBits = [self jsonToInt:@"filter-categoryBits" jsonObj:fixtureValue defaultValue:0x0001];
    fixtureDef.filter.maskBits = [self jsonToInt:@"filter-maskBits" jsonObj:fixtureValue defaultValue:0xFFFF];
    fixtureDef.filter.groupIndex = [self jsonToInt:@"filter-groupIndex" jsonObj:fixtureValue defaultValue:0];
    
    id fixtureValueCircle = [fixtureValue objectForKey:@"circle"];
    id fixtureValueEdge = [fixtureValue objectForKey:@"edge"];
    id fixtureValueLoop = [fixtureValue objectForKey:@"loop"];
    id fixtureValueChain = [fixtureValue objectForKey:@"chain"];
    id fixtureValuePolygon = [fixtureValue objectForKey:@"polygon"];

//    LOG_DEBUG(@"fixtureValueCircle -> %@", fixtureValueCircle);
//    LOG_DEBUG(@"fixtureValuePolygon -> %@", fixtureValuePolygon);
    
    
    if ( fixtureValueCircle  ) {
//        LOG_DEBUG(@"create fixture circle");
        b2CircleShape circleShape;
        circleShape.m_radius = [self jsonToFloat:@"radius" jsonObj:fixtureValueCircle defaultValue:0];
        circleShape.m_p =  [self jsonToVec:@"center" jsonObj:fixtureValueCircle];
        fixtureDef.shape = &circleShape;
        fixture = body->CreateFixture(&fixtureDef);
    }
    else if ( fixtureValueEdge ) {

        b2EdgeShape edgeShape;
        edgeShape.m_vertex1 =  [self jsonToVec:@"vertex1" jsonObj:fixtureValueEdge];
        edgeShape.m_vertex2 = [self jsonToVec:@"vertex2" jsonObj:fixtureValueEdge];
        edgeShape.m_hasVertex0 = [self jsonToBool:@"hasVertex0" jsonObj:fixtureValueEdge defaultValue:NO];
        edgeShape.m_hasVertex3 = [self jsonToBool:@"hasVertex3" jsonObj:fixtureValueEdge defaultValue:NO];
        if ( edgeShape.m_hasVertex0 ) edgeShape.m_vertex0 =  [self jsonToVec:@"vertex0" jsonObj:fixtureValueEdge];
        if ( edgeShape.m_hasVertex3 ) edgeShape.m_vertex3 = [self jsonToVec:@"vertex3" jsonObj:fixtureValueEdge];
        fixtureDef.shape = &edgeShape;
        fixture = body->CreateFixture(&fixtureDef);
    }
    else if ( fixtureValueLoop) { //support old format (r197)
        b2ChainShape chainShape;
        id fixtureValueLoopVertices = [fixtureValueLoop objectForKey:@"vertices"];
        NSArray *fixtureValueLoopVerticesXArr = [fixtureValueLoopVertices objectForKey:@"x"];
        int numVertices = [fixtureValueLoopVerticesXArr count];
        b2Vec2* vertices = new b2Vec2[numVertices];
        for (int i = 0; i < numVertices; i++){
            vertices[i] = [self jsonToVec:@"vertices" jsonObj:fixtureValueLoop index:i];
        }
        chainShape.CreateLoop(vertices, numVertices);
        fixtureDef.shape = &chainShape;
        fixture = body->CreateFixture(&fixtureDef);
        delete[] vertices;
    }
    else if ( fixtureValueChain) {
        
        
//        LOG_DEBUG(@"create shape chain ");
        
        b2ChainShape chainShape;
        id fixtureValueChainVertices = [fixtureValueChain objectForKey:@"vertices"];
        NSArray *fixtureValueChainVerticesXArr = [fixtureValueChainVertices objectForKey:@"x"];
        int numVertices = [fixtureValueChainVerticesXArr count];
        b2Vec2* vertices = new b2Vec2[numVertices];
        
        
        // save ground key point to generate actor
        if (_filter.categoryBits == b2ActorCategoryGround) {
//            LOG_DEBUG(@"This is a chain shape of ground");
            _verticesG = [[b2Vec2List alloc] initWithSize:numVertices];
            for (int i = 0; i < numVertices; i++){
                vertices[i] = [self jsonToVec:@"vertices" jsonObj:fixtureValueChain index:i];
                [_verticesG addValue:[self jsonToVecOffset:@"vertices" jsonObj:fixtureValueChain index:i]];
                
//                b2Vec2 vec = [_verticesG getValueAt:i];
//                LOG_DEBUG(@"vec -> %f %f", vec.x, vec.y);
            }
            
            LOG_DEBUG(@"_verticesG count -> %d", [_verticesG count]);
        }else{
            for (int i = 0; i < numVertices; i++){
                vertices[i] = [self jsonToVec:@"vertices" jsonObj:fixtureValueChain index:i];
            }
        }
        
        
        
        chainShape.CreateChain(vertices, numVertices);
        chainShape.m_hasPrevVertex = [self jsonToBool:@"hasPrevVertex" jsonObj:fixtureValueChain defaultValue:NO];
        chainShape.m_hasNextVertex = [self jsonToBool:@"hasNextVertex" jsonObj:fixtureValueChain defaultValue:NO];
        if ( chainShape.m_hasPrevVertex ) chainShape.m_prevVertex = [self jsonToVec:@"prevVertex" jsonObj:fixtureValueChain];
        if ( chainShape.m_hasNextVertex ) chainShape.m_nextVertex = [self jsonToVec:@"nextVertex" jsonObj:fixtureValueChain];
        fixtureDef.shape = &chainShape;
        fixture = body->CreateFixture(&fixtureDef);
        delete[] vertices;
    }
    else if ( fixtureValuePolygon ) {
//        LOG_DEBUG(@"create fixture fixtureValuePolygon");
//        return;
        b2Vec2 vertices[b2_maxPolygonVertices];
        id fixtureValuePolygonVertices = [fixtureValuePolygon objectForKey:@"vertices"];
        NSArray *fixtureValuePolygonVerticesXArr = [fixtureValuePolygonVertices objectForKey:@"x"];
        int numVertices = [fixtureValuePolygonVerticesXArr count];
//        LOG_DEBUG(@"numVertices -> %d", numVertices);
//        return;
        if ( numVertices > b2_maxPolygonVertices ) {
            LOG_INFO(@"Ignoring polygon fixture with too many vertices.\n");
        }
        else if ( numVertices < 2 ) {
            LOG_INFO(@"Ignoring polygon fixture less than two vertices.\n");
        }
        else if ( numVertices == 2 ) {
            LOG_INFO (@"Creating edge shape instead of polygon with two vertices.\n");
            b2EdgeShape edgeShape;
            edgeShape.m_vertex1 = [self jsonToVec:@"vertices" jsonObj:fixtureValuePolygon index:0];
            edgeShape.m_vertex2 = [self jsonToVec:@"vertices" jsonObj:fixtureValuePolygon index:1];
            fixtureDef.shape = &edgeShape;
            fixture = body->CreateFixture(&fixtureDef);
        }
        else {
            b2PolygonShape polygonShape;
            for (int i = 0; i < numVertices; i++){
                
//                LOG_DEBUG(@"vertices -> %@", [fixtureValuePolygon objectForKey:@"vertices"]);
//                return;
                vertices[i] = [self jsonToVec:@"vertices" jsonObj:fixtureValuePolygon index:i];
//                return;
            }
            polygonShape.Set(vertices, numVertices);
            fixtureDef.shape = &polygonShape;
            fixture = body->CreateFixture(&fixtureDef);
        }
    }
    
    
    
    
//    LOG_DEBUG(@"fixtureName -> %@ -> %@", fixtureName, fixtureValue);
    
//    if ( [fixtureName isEqualToString:@""]) {
////        setFixtureName(fixture, fixtureName.c_str());
//    }else{
//        
//    }
    
    //set aabb

    
    if ([fixtureName isEqualToString:@"aabb"]) {
        
        //Yeah every fixture has 1 to m child fixtures. For fixtures with a single child (circle, polygon, edge), the index is zero. For chain shapes, the index is 0 to m-1.
        _aabb = [self combineAABBForFixture:fixture];
        
        _proxyId = [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil];
        _actorId = _proxyId;
        
        
        b2BodyBaseIdx = bodyIndex;
        
        LOG_DEBUG(@"b2BodyBaseIdx -> %d", bodyIndex);
        LOG_DEBUG(@"aabb lower %f %f  upper %f %f", _aabb.lowerBound.x,_aabb.lowerBound.y,_aabb.upperBound.x,_aabb.upperBound.y);
        
//        [[HSDynamicTreeManager sharedInstance] destoryProxy:_proxyId];
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil];  //proxy 1
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 2
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 3
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 4
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 5
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 6
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 7
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 8
//        
//        [[HSDynamicTreeManager sharedInstance] destoryProxy:5]; // proxy 5
//        
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 5
//        [[HSDynamicTreeManager sharedInstance] createProxy:_aabb userData:nil]; // proxy 9
        
//        [[HSDynamicTreeManager sharedInstance] destoryProxy:_proxyId];
        
//        LOG_DEBUG(@"create Proxy in dynamic tree -> %d", _proxyId);
    }
    
    
    
//    return fixture;
//    LOG_DEBUG(@"create fixture end ===================");
}


- (void)j2b2Joint:(id)jointValue{
    b2Joint* joint = NULL;
    
    int bodyIndexA = [self jsonToInt:@"bodyA" jsonObj:jointValue defaultValue:0];
    int bodyIndexB = [self jsonToInt:@"bodyB" jsonObj:jointValue defaultValue:0];
    
//    if ( bodyIndexA >= (int)m_bodies.size() || bodyIndexB >= (int)m_bodies.size() )
//        return NULL;
    
    //keep these in scope after the if/else below
    b2RevoluteJointDef revoluteDef;
    b2PrismaticJointDef prismaticDef;
    b2DistanceJointDef distanceDef;
    b2PulleyJointDef pulleyDef;
    b2MouseJointDef mouseDef;
    b2GearJointDef gearDef;
    b2WheelJointDef wheelDef;
    b2WeldJointDef weldDef;
    b2FrictionJointDef frictionDef;
    b2RopeJointDef ropeDef;
    
    //will be used to select one of the above to work with
    b2JointDef* jointDef = NULL;
    
    b2Vec2 mouseJointTarget;
    NSString *type =[self jsonToString:@"type" jsonObj:jointValue];
    
    if ( [type isEqualToString:@"revolute"] )
    {
        jointDef = &revoluteDef;
        revoluteDef.localAnchorA = [self jsonToVec:@"anchorA" jsonObj:jointValue];
        revoluteDef.localAnchorB = [self jsonToVec:@"anchorB" jsonObj:jointValue];
        revoluteDef.referenceAngle = [self jsonToFloat:@"refAngle" jsonObj:jointValue defaultValue:0];
        revoluteDef.enableLimit =  [self jsonToBool:@"enableLimit" jsonObj:jointValue defaultValue:NO];
        revoluteDef.lowerAngle = [self jsonToFloat:@"lowerLimit" jsonObj:jointValue defaultValue:0];
        revoluteDef.upperAngle = [self jsonToFloat:@"upperLimit" jsonObj:jointValue defaultValue:0];
        revoluteDef.enableMotor = [self jsonToBool:@"enableMotor" jsonObj:jointValue defaultValue:NO];
        revoluteDef.motorSpeed = [self jsonToFloat:@"motorSpeed" jsonObj:jointValue defaultValue:0];
        revoluteDef.maxMotorTorque = [self jsonToFloat:@"maxMotorTorque" jsonObj:jointValue defaultValue:0];
    }
    else if ( [type isEqualToString:@"prismatic"] )
    {
        jointDef = &prismaticDef;
        prismaticDef.localAnchorA = [self jsonToVec:@"anchorA" jsonObj:jointValue];
        prismaticDef.localAnchorB = [self jsonToVec:@"anchorB" jsonObj:jointValue];
        if ( ![jointValue objectForKey:@"localAxisA"]){
            prismaticDef.localAxisA = [self jsonToVec:@"localAxisA" jsonObj:jointValue];
        }else{
            prismaticDef.localAxisA = [self jsonToVec:@"localAxis1" jsonObj:jointValue];
        }
        prismaticDef.referenceAngle = [self jsonToFloat:@"refAngle" jsonObj:jointValue defaultValue:0];
        prismaticDef.enableLimit = [self jsonToBool:@"enableLimit" jsonObj:jointValue defaultValue:NO];
        prismaticDef.lowerTranslation = [self jsonToFloat:@"lowerLimit" jsonObj:jointValue defaultValue:0];
        prismaticDef.upperTranslation = [self jsonToFloat:@"upperLimit" jsonObj:jointValue defaultValue:0];
        prismaticDef.enableMotor = [self jsonToBool:@"enableMotor" jsonObj:jointValue defaultValue:NO];
        prismaticDef.motorSpeed =  [self jsonToFloat:@"motorSpeed" jsonObj:jointValue defaultValue:0];
        prismaticDef.maxMotorForce = [self jsonToFloat:@"maxMotorForce" jsonObj:jointValue defaultValue:0];
    }
    else if ( [type isEqualToString:@"distance"] )
    {
        jointDef = &distanceDef;
        distanceDef.localAnchorA = [self jsonToVec:@"anchorA" jsonObj:jointValue];
        distanceDef.localAnchorB = [self jsonToVec:@"anchorB" jsonObj:jointValue];
        distanceDef.length =  [self jsonToFloat:@"length" jsonObj:jointValue defaultValue:0];
        distanceDef.frequencyHz = [self jsonToFloat:@"frequency" jsonObj:jointValue defaultValue:0];
        distanceDef.dampingRatio = [self jsonToFloat:@"dampingRatio" jsonObj:jointValue defaultValue:0];
    }
    else if ( [type isEqualToString:@"pulley"] )
    {
        jointDef = &pulleyDef;
        pulleyDef.groundAnchorA = [self jsonToVec:@"groundAnchorA" jsonObj:jointValue];
        pulleyDef.groundAnchorB = [self jsonToVec:@"groundAnchorB" jsonObj:jointValue];
        pulleyDef.localAnchorA = [self jsonToVec:@"anchorA" jsonObj:jointValue];
        pulleyDef.localAnchorB = [self jsonToVec:@"anchorB" jsonObj:jointValue];
        pulleyDef.lengthA =   [self jsonToFloat:@"lengthA" jsonObj:jointValue defaultValue:0];
        pulleyDef.lengthB = [self jsonToFloat:@"lengthB" jsonObj:jointValue defaultValue:0];
        pulleyDef.ratio = [self jsonToFloat:@"ratio" jsonObj:jointValue defaultValue:0];
    }
//    else if ( [type isEqualToString:@"mouse"] )
//    {
//        jointDef = &mouseDef;
//        mouseJointTarget = jsonToVec("target", jointValue);
//        mouseDef.target = jsonToVec("anchorB", jointValue);//alter after creating joint
//        mouseDef.maxForce = jsonToFloat("maxForce", jointValue);
//        mouseDef.frequencyHz = jsonToFloat("frequency", jointValue);
//        mouseDef.dampingRatio = jsonToFloat("dampingRatio", jointValue);
//    }
    else if ( [type isEqualToString:@"gear"] )
    {
        jointDef = &gearDef;
        int jointIndex1 = [self jsonToInt:@"joint1" jsonObj:jointValue defaultValue:0];
        int jointIndex2 = [self jsonToInt:@"joint2" jsonObj:jointValue defaultValue:0];
        
        gearDef.joint1 = [m_joints getValueAt:jointIndex1];
        gearDef.joint2 = [m_joints getValueAt:jointIndex2];
        
        LOG_DEBUG(@"jointIndex1:%d jointIndex2:%d", jointIndex1, jointIndex2);
        
        gearDef.ratio = [self jsonToFloat:@"ratio" jsonObj:jointValue defaultValue:0];
    }
    else if ( [type isEqualToString:@"wheel"] )
    {
        jointDef = &wheelDef;
        wheelDef.localAnchorA =  [self jsonToVec:@"anchorA" jsonObj:jointValue];
        wheelDef.localAnchorB =  [self jsonToVec:@"anchorB" jsonObj:jointValue];
        wheelDef.localAxisA =  [self jsonToVec:@"localAxisA" jsonObj:jointValue];
        wheelDef.enableMotor = [self jsonToBool:@"enableMotor" jsonObj:jointValue defaultValue:NO];
        wheelDef.motorSpeed = [self jsonToFloat:@"motorSpeed" jsonObj:jointValue defaultValue:0];
        wheelDef.maxMotorTorque =  [self jsonToFloat:@"maxMotorTorque" jsonObj:jointValue defaultValue:0];
        wheelDef.frequencyHz =  [self jsonToFloat:@"springFrequency" jsonObj:jointValue defaultValue:0];
        wheelDef.dampingRatio =  [self jsonToFloat:@"springDampingRatio" jsonObj:jointValue defaultValue:0];
    }
    else if ( [type isEqualToString:@"weld"] )
    {
        jointDef = &weldDef;
        weldDef.localAnchorA = [self jsonToVec:@"anchorA" jsonObj:jointValue];
        weldDef.localAnchorB = [self jsonToVec:@"anchorB" jsonObj:jointValue];
        weldDef.referenceAngle = 0;//jsonToFloat("refAngle", jointValue);
    }
    else if ( [type isEqualToString:@"friction"] )
    {
        jointDef = &frictionDef;
        frictionDef.localAnchorA = [self jsonToVec:@"anchorA" jsonObj:jointValue];
        frictionDef.localAnchorB = [self jsonToVec:@"anchorB" jsonObj:jointValue];
        frictionDef.maxForce =  [self jsonToFloat:@"maxForce" jsonObj:jointValue defaultValue:0];
        frictionDef.maxTorque = [self jsonToFloat:@"maxTorque" jsonObj:jointValue defaultValue:0];
    }
    else if ( [type isEqualToString:@"rope"] )
    {
        jointDef = &ropeDef;
        ropeDef.localAnchorA = [self jsonToVec:@"anchorA" jsonObj:jointValue];
        ropeDef.localAnchorB = [self jsonToVec:@"anchorB" jsonObj:jointValue];
        ropeDef.maxLength = [self jsonToFloat:@"maxLength" jsonObj:jointValue defaultValue:0];
    }
    
    if ( jointDef ) {
        //set features common to all joints
        jointDef->bodyA = [m_bodies getValueAt:bodyIndexA];
        jointDef->bodyB = [m_bodies getValueAt:bodyIndexB];
        
        LOG_DEBUG(@"bodyIndexA:%d bodyIndexB:%d", bodyIndexA, bodyIndexB);
        
//        LOG_DEBUG(@"bodyA:%i bodyB:%i", jointDef->bodyA, jointDef->bodyB);
    
        
        jointDef->collideConnected = [self jsonToBool:@"collideConnected" jsonObj:jointValue defaultValue:NO];
        joint = world->CreateJoint(jointDef);
        
//        if ( type == "mouse" ){
//            ((b2MouseJoint*)joint)->SetTarget(mouseJointTarget);
//        }
        
        NSString *jointName = [self jsonToString:@"name" jsonObj:jointValue];
        if ( ![jointName isEqualToString:@""] ) {
            [m_joints addValue:joint];
        }else{
            [m_joints addValue:joint withName:jointName];
        }
    }
    
//    return joint;
}


- (b2AABB)combineAABBForFixture:(b2Fixture *)fixture{
    b2AABB tmpAABB;
    int childCount = fixture->GetShape()->GetChildCount();
    LOG_DEBUG(@"childCount -> %d", childCount);
    for (int i=0; i<childCount; i++) {
        
        if (i==0) {
            tmpAABB = fixture->GetAABB(i);
            continue;
        }
        tmpAABB.Combine(fixture->GetAABB(i));
    }

    return tmpAABB;
}

#pragma mark - json utils

- (b2Vec2)jsonToVecOffset:(NSString *)key jsonObj:(id)jsonObj{
    return [self jsonToVecOffset:key jsonObj:jsonObj index:-1];
}


- (b2Vec2)jsonToVecOffset:(NSString *)key jsonObj:(id)jsonObj index:(int)index{
    id value = [jsonObj objectForKey:key];
    b2Vec2 vec;
//    LOG_DEBUG(@"key-> %@ value -> %@", key,value);
    
    if ([value isKindOfClass:[NSNumber class]]) { //因为表示的是速度，所以不用加offset
        return b2PosOffset;
    }
    
    if (index > -1) {
        NSArray *xArr = [value objectForKey:@"x"];
        NSArray *yArr = [value objectForKey:@"y"];
        
        vec.x = [[xArr objectAtIndex:index] floatValue];
        vec.y = [[yArr objectAtIndex:index] floatValue];
    }
    else {
        vec.x = [self jsonToFloat:@"x" jsonObj:value defaultValue:0];
        vec.y = [self jsonToFloat:@"y" jsonObj:value defaultValue:0];
    }
    
    vec += b2PosOffset;
    
    return vec;
//    return b2Vec2(vec.x+b2PosOffset.x, vec.y+b2PosOffset.y);
}

- (b2Vec2)jsonToVec:(NSString *)key jsonObj:(id)jsonObj{
    return [self jsonToVec:key jsonObj:jsonObj index:-1];
}

- (b2Vec2)jsonToVec:(NSString *)key jsonObj:(id)jsonObj index:(int)index{
    id value = [jsonObj objectForKey:key];
    b2Vec2 vec;
    //    LOG_DEBUG(@"key-> %@ value -> %@", key,value);
    
    if ([value isKindOfClass:[NSNumber class]]) { //因为表示的是速度，所以不用加offset
        return b2Vec2 (0,0);
    }
    
    if (index > -1) {
        NSArray *xArr = [value objectForKey:@"x"];
        NSArray *yArr = [value objectForKey:@"y"];
        
        vec.x = [[xArr objectAtIndex:index] floatValue];
        vec.y = [[yArr objectAtIndex:index] floatValue];
    }
    else {
        vec.x = [self jsonToFloat:@"x" jsonObj:value defaultValue:0];
        vec.y = [self jsonToFloat:@"y" jsonObj:value defaultValue:0];
    }
    
    return vec;
    //    return b2Vec2(vec.x+b2PosOffset.x, vec.y+b2PosOffset.y);
}


- (int)jsonToInt:(NSString *)key jsonObj:(id)jsonObj defaultValue:(int)defalutValue{
    id value = [jsonObj objectForKey:key];
//    LOG_DEBUG(@"key-> %@ value -> %@", key,value);
    
    if (value == nil) {
        return defalutValue;
    }
    
    return [value integerValue];
}

- (CGFloat)jsonToFloat:(NSString *)key jsonObj:(id)jsonObj defaultValue:(CGFloat)defaultValue{
    id value = [jsonObj objectForKey:key];
//    LOG_DEBUG(@"key-> %@ value -> %@", key,value);
    
    if (value == nil) {
        return defaultValue;
    }
    
    return [value floatValue];
}

- (NSString *)jsonToString:(NSString *)key jsonObj:(id)jsonObj{
    id value = [jsonObj objectForKey:key];
//    LOG_DEBUG(@"key-> %@ value -> %@", key,value);
    return value;
}


//need different default value 
- (BOOL)jsonToBool:(NSString *)key jsonObj:(id)jsonObj defaultValue:(BOOL)defaultValue{
    id value = [jsonObj objectForKey:key];
//    LOG_DEBUG(@"key-> %@ value -> %@", key,value);
    if (value == nil)  return defaultValue;
    if([value integerValue]==0) return NO;
    
    return YES;
}


@end
