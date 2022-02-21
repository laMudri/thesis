Rebuttal
========

Thank you to the reviewers for their careful reviews and kind comments
and suggestions. We have commented below on the major questions and
concerns brought up by the reviews, and given our suggestions for how
we will amend in the paper for any further revision.

Reviewer A
----------

> Please clarify the "Page 9: As far as I can tell, the *c and I*c and
> r.c used in the definition of [[_]]p are not defined defined
> anywhere. " to help me understand this definition.

These are liftings of the corresponding bunched connectives from page
5 to be indexed by vector/context pairs. We will make this clear in
any revised version. The $\dot\times$ product works because it is a
polymorphic pointwise use of $\times$ for any indexing set. Our
notation on page 5 implies that it is only defined for vectors, but it
is actually polymorphic. We will state this explicitly.

> It might be worth giving some general guidance about how to
> think about the orientation of <=

We think of the ordering `x <= y` as convertibility; so that something
labelled with `x` is sufficient to supply a demand of `y`. This gives
the upside-down ordering when compared the standard natural
numbers. Abel and Bernardy (ICFP 2020) make the same choice.

> In the "An element of a chosen posemiring" paragraph, it would help
> to define <= on vectors (the green scripty P's and Q's that occur in
> the typing rules) --- I assume this means pointwise <= of resources?

Yes, this is the pointwise ordering.

> It would have helped me to have an explicit comment about what
> isomorphisms you're eliding when representing resource vectors (the
> script P and script Q) in different ways.

Conceptually, contexts with usage annotations are pairs of vectors,
one of semiring values and one of types. We have found it useful in
the formalisation to store these vectors in an "unnormalised" fashion
as trees that record their history of appends used to construct
them. This non-canonicity does not cause a problem because we can
always apply renaming to shift to a different association
structure. The isomorphisms come from renamings. We never compare
contexts for equality directly, we only make demands on what variables
appear in them and what their usage annotations and types are. This is
a minor formalisation "trick" that is difficult to get across in a
paper intended for a general audience.

> Page 5, bottom: As far as I understand, the resource 0 doesn't have
> any special status with respect to the preorder <=. So why does R <=
> 0 get a "connective" in the framework

The vector 0 is special with respect to the vector space structure,
being the unit for the addition. There is no multiplication structure
between vectors, and so no use for the vector of all 1s. I* is also
defined with `R <= 0` to ensure it is the unit of the * connective.

> In Definition 5.1, I found the role of the Q' confusing at
> first

You are correct about what it is used for -- it is a convenience. We
will add a comment to clarify.

> [Agda notation]

We will track these down and add the necessary definitions.

> It would be good to give some empirical sense for how well this
> resource elaborator works --- what examples is it able to handle,
> what times out, etc.?

We will elaborate on the elaborator, as also suggested by the other
reviewers.

> The type systems for Amortized Automated Resource Analysis by
> Hofman, Jost, Hoffmann, etc. have the flavor of these
> resource-annotated type systems -- can you encode those?

We can't definitively say, but we think the answer is that we cannot
directly encode these systems because the contraction rule they use
does not fully preserve the types: a variable of type A can be
duplicated to two variables of types A1 and A2 whose integrated
potentials add up to the ones in the type A. In our system,
duplicating a variable affects its top-level usage annotation, but
preserves its type. It may be possible to encode a system for
amortised reasoning however.

> It would also be nice to show that you can encode a system with
> "non-logical" rules, e.g. some of the primitives for differential
> privacy in [18].

This is certainly possible. For the Reed and Pierce system, we would
need to add rules for the graded differentially private distribution
monad, which in our system is just some more rules.

> What are the prospects for extending the framework beyond simple
> types, e.g. to handle resource polymorphism (quantification over
> resources) or dependent types?

We think that extension to polymorphism (over types or usage
annotations) would be relatively straightforward conceptually given
that the kinding or resourcing contexts would not interact with the
substructural parts. It would become harder to make a generic
elaborator, however, due to the need to reason about open terms in the
semiring (something that the Granule systems needs to use external
solvers for). Extension to dependent types is much harder; though we
think that our insights will help extend any formalisation of non
substructural dependent types to having semiring resource annotations.

Reviewer B
----------

> Can only really be followed by an expert in this kind of extremely
> general formalization in Agda.

We have tried to mitigate this by using examples throughout. For a
revised final version we will guide our examples by trying to get
across how the framework is used in practice. For example, an example
of using the elaborator defined in Section 7.3, as suggested.

> Extremely dense in notation and fairly sparse in giving intuitions
> of what's going on.

In addressing reviewer C's points, we will add more intuition to help
readers used to extrinsic presentations of type systems in
Section 3. We will simplify Section 4, as explained below. We will
also more high-level discussion in the later sections on what is
possible with the syntactic traversals for generic metatheory, again
see below. To make space will we move some of the technical content of
Section 5 to an appendix to concentrate more on the high level ideas
of using linear algebra.

> Explanation after page 8 (construction of terms) is too opaque

We can simplify this section by removing the I--OpenFam and I--OpenExt
definitions, since I is always Ty. We will then add proper
explanations for the remaining three defnitions (OpenType, OpenFam and
OpenExtFam) and point to the places where they are required in our
development. The more general definitions are not actually used until
the `extend` function on page 18, where we will explicitly say that we
need the extra generality in a revised version.

> How does one use this for *metatheory* as opposed just creating
> syntaxes.
and
> What kind of metatheory can you do?

We can define functions such as generic renaming and substitution, and
generic denotational semantics. But we cannot yet (easily) reason
about them beyond their types. We expect that the `Simulation`
construct from the Allais et al. paper [3] will smoothly transfer to
this setting, which allow us to prove equational properties of these
traversals. For example, the substitution of a composition of two
simultaneous substitutions being the composition of two separate
subsitutions. In this paper, we wanted to show that the core of Allais
et al. transfers to the semiring-annotated setting, where even
defining the syntax and the operations of renaming and substitution
are nontrivial and require a linearly algebraic approach. We leave
transfer of the equational reasoning principles to future work. We
expect that given our foundational work, equational reasoning will
follow easily.

> what kind of "things" can I expect to reasonably define as
> traversals?
and
> The applicability of the framework in terms of metareasoning beyond
> the use cases in the paper is not really discussed and the
> automation/elaborator is not really exercised in the presentation.

Traversals are a "nicer" fold / recursion principle over the syntax,
that automatically handles dealing with updating of parameters when
going under binders. This is particularly useful in the renaming and
substitution cases, where the parameter is the renaming or
substitution. Using a traversal saves on repeated work that would be
required if one were to do this directly with the "native" recursion
principle for the type of Terms. The key point is that defining
renaming and substitution for substructural systems is not trivial,
and our framework yields a generic definition for a wide range of
such systems.

> An elaborator for this is great, but how can I use it?

We will give an actual use of the elaborator to show how it is used in
the context of Examples 8-10 (the monotone subtraction function),
which will also be compressed to give more space to discussion of the
framework.

> Concretely, I think some of the examples in the paper (e.g. Examples
> 8-10) could be cut for extra space so that definitions, roadmaps and
> actual explanations can be given in a way that makes the paper
> understandable to a wider audience.

We take the reviewer's point that examples 8-10 are more on an example
application of one part of the metatheory (a denotational semantics)
than the overall picture. We will do as the reviewer suggests to
compress these examples to give more space for high level discussion
of the features of the framework. In particular, we will add a short
discussion of how to do denotational semantics for other systems
within the framework. The main point of this section is that our
framework provides a way to formalise much of Abel and Bernardy's ICFP
2020 paper, including the free theorems arising from the usage
annotations.

Reviewer C
----------

> Basically: Expand section 3, starting with a non-intrinsic version
> of Figure 1; explain how to get from the non-intrinsic system to
> Figure 1; explain how to get to Figure 2.

Good idea. We agree that Section 3 is the key section to understanding
our approach. Our plan is to expand the discussion of the intrinsic
presentation in Figure 1 by comparing them to the extrinsic
presentations directly. Hopefully this will lead the reader more
gently to the final presentation in Fig 2. As suggested, comparing our
approach to HOAS's use of ambient contexts is also a useful way to
help readers' intuitions.

> missing some work that may be related: ambient contexts are used in
> higher-order abstract syntax (as in LF/Twelf and its successors)

We will add a discussion of the use of ambient contexts in HOAS
presentations. The interesting point there, we think, is that to
easily encode substructural systems, the common approach is to
replicate the substructural discipline in the logical framework (e.g.,
Linear LF). Here, we are exploiting the same idea internally in Agda
by using the bunched connectives, which means that we don't need to
switch to a completely new logical framework. Thank you for the prompt
to discuss this related work.

> In Definition 2, in the first line, I take it that → is implication,

Yes, this is implication. We will write this out using English words
instead.

> Is the "Rγ" notation chosen for a reason, compared to something like
> R; γ?

We felt that this notation was more concise. Figure 1 with $(R; \gamma)$
everywhere would be much messier, in our opinion.
